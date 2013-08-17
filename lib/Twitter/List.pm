package Twitter::List;

use 5.014;
use feature 'say';
use strict;
use warnings;

use Net::Twitter;
use Sub::Exporter -setup => { exports => ['create_list','populate_list','debug','set_debug'] };
use DateTime;

our $dbg = 0;

sub new
{
  my $package = shift;
  my $class = ref($package) || $package;
  my $self = {};
  
  bless $self, $class;
  return $self;
}

sub create_list
{
    my ($class, $nt, $listname) = @_;
    my $result = $nt->create_list( $listname );
    debug( "Creating list \@$result->{user}->{screen_name}/$listname (id: $result->{id}) on ", _dateTimeISO8601() , "..." );
    return ($result->{id}, $result->{user}->{id}, $result->{user}->{screen_name}, $result->{slug});
}

sub populate_list
{
    my ($class, $nt, $list_id, $slug, $user_id, $u_screen_name, $twitter_ids) = @_; 

    my $members_total = 0;
    my $members_added = 0;

    debug( "Populating $slug (id: $list_id)..." );

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
                debug( "...Added member '\@$member_id' to list (id: $list_id)" );
            };
        next if !defined($user_record);

        # Some entered full URLs instead of just their twitter ids. 
        # This may be a MetaCPAN input validation fail.
        next if $user_record =~ /^https?:\/\//;
    }
1;
}

sub _dateTimeISO8601
{
    return DateTime->now()->ymd, "T", DateTime->now()->hms;
}

sub debug
{
    my $class = shift if ref($_[0]);

    my $str = join '', @_;

    if ( $Twitter::List::dbg )
    {
        say _dateTimeISO8601(), " - ", $str;
    }
1;
}

sub set_debug
{
    my $class = shift if ref($_[0]);
    my $dbg = shift;

    if ( defined($dbg) && $dbg eq 1 )
    {
        $Twitter::List::dbg = $dbg;
    }
1;
}

1;