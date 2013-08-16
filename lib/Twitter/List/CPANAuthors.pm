package Twitter::List::CPANAuthors;

use 5.014;
use feature 'say';
use strict;
use warnings;

use Net::Twitter;
use ElasticSearch;
use Sub::Exporter -setup => { exports => ['create'] };
use DateTime;
use Data::Dumper;

our $dbg = 0;

sub new
{
  my $package = shift;
  my $class = ref($package) || $package;
  my $self = {};
  $self->{dbg} = 0;
  
  bless $self, $class;
  return $self;
}

sub create
{
    my ( $class, %args ) = @_;
    _set_debug( $args{dbg} );

    my $nt = Net::Twitter->new(
        traits              => [qw/API::RESTv1_1/],
        consumer_key        => $args{consumer_key},
        consumer_secret     => $args{consumer_secret},
        access_token        => $args{access_token},
        access_token_secret => $args{access_token_secret},
    );

    my @twitter_ids = @{ _scroller() };
    my ( $list_id, $user_id, $u_screen_name, $slug ) = _create_list( $nt, $args{listname} );
    _populate_list( $nt, $list_id, $slug, $user_id, $u_screen_name, \@twitter_ids );
    _debug( "...List $slug (id: $list_id) complete on ", _dateTimeISO8601() , "." );
}

sub _dateTimeISO8601
{
    return DateTime->now()->ymd, "T", DateTime->now()->hms;
}

sub _create_list
{
    my ($nt, $listname) = @_;
    my $result = $nt->create_list( $listname );
    _debug( "Creating list \@$result->{user}->{screen_name}/$listname (id: $result->{id}) on ", _dateTimeISO8601() , "..." );
    return ($result->{id}, $result->{user}->{id}, $result->{user}->{screen_name}, $result->{slug});
}

sub _populate_list
{
    my ($nt, $list_id, $slug, $user_id, $u_screen_name, $twitter_ids) = @_; 

    my $members_total = 0;
    my $members_added = 0;

    _debug( "Populating $slug (id: $list_id) on ", _dateTimeISO8601() , "..." );

    for my $member_id ( @{ $twitter_ids} )
    {
        #--------------------------------------------------------------#
        # The eval block below is used to trigger the 'add_list_member'
        # method on the $nt object below without consequence.
        # 
        # If we call $nt->add_list_member without an eval, and the user
        # ($member_id) doesn't exist, the program will crash with 
        # "Cannot find specified user at lib/Twitter/List/CPANAuthors.pm line 57".
        # 
        # I've looked into detecting the existence of a user account before
        # attempting to add the user to the list, but available options are
        # limited and inflexible.
        #
        # One option is to use lookup_users (API v1.1), but it is rate-limited,
        # and would require an extra transaction for each user I wanted to verify
        # which makes things slow(er).
        #
        # The other option was to use user_timeline (API v1.1) with a hack that
        # looks something like this: http://stackoverflow.com/a/12263573/282982,
        # but again that required double the transactions, and Net::Twitter
        # (version 4.00007) doesn't support 'suppress_response_codes' as described here:
        #  https://dev.twitter.com/docs/things-every-developer-should-know 
        #
        # Finally, using add_list_members (plural) limits me to adding only 100
        # members at a time, but has yet to be tested for performance.
        #
        # Using the boolean result of an eval seems to be the fastest way
        # to move forward at the moment.
        #--------------------------------------------------------------#
        my $user_record = eval
            {
                my $result = $nt->add_list_member(
                    {
                        list_id           => $list_id,
                        screen_name       => $member_id,
                        owner_screen_name => $u_screen_name,
                        owner_id          => $u_screen_name
                    }
                );
                _debug( "Added member '\@$member_id' to list (id: $list_id) at ", _dateTimeISO8601() , "." );
            };
        next if !defined($user_record);

        # Some entered full URLs instead of just their twitter ids. 
        # This may be a MetaCPAN input validation fail.
        next if $user_record =~ /^https?:\/\//;
    }
1;
}

sub _es {
    return ElasticSearch->new(
        no_refresh  => 1,
        servers     => 'api.metacpan.org',
        trace_calls => (0||undef),
        transport   => 'curl',
    );
}

sub _scroller
{
    my @cpan_twitter_ids = ();

    my $scroller = _es()->scrolled_search(
        query  => { match_all => {} },
        filter => { term      => { 'author.profile.name' => 'twitter' } },
        search_type => 'scan',
        scroll      => '5m',
        index       => 'v0',
        type        => 'author',
        size        => 100,
    );

    while ( my $result = $scroller->next ) {
        my $author = $result->{_source};

        foreach my $profile ( @{ $author->{profile} } ) {
            next unless $profile->{name} eq 'twitter';
            next unless defined( $profile->{id} ) && $profile->{id} ne "";

            push @cpan_twitter_ids, $profile->{id};
            last;
        }
    }

    return \@cpan_twitter_ids;
}

sub _debug
{
    my $str = join '', @_;

    if ( $Twitter::List::CPANAuthors::dbg )
    {
        say $str;
    }
1;
}

sub _set_debug
{
    my ($dbg) = @_;

    if ( defined($dbg) && $dbg eq 1 )
    {
        $Twitter::List::CPANAuthors::dbg = $dbg;
    }
1;
}

1;

