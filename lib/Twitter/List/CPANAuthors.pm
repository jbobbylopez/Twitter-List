package Twitter::List::CPANAuthors;
use base ('Twitter::List');

use 5.014;
use feature 'say';
use strict;
use warnings;

use Net::Twitter;
use ElasticSearch;
use Sub::Exporter -setup => { exports => ['create'] };
use DateTime;

sub new
{
  my $package = shift;
  my $class = ref($package) || $package;
  my $self = {};
  
  bless $self, $class;
  return $self;
}

sub create
{
    my ( $class, %args ) = @_;
    
    my $TL = Twitter::List->new();

    $TL->set_debug( $args{dbg} );

    my $nt = Net::Twitter->new(
        traits              => [qw/API::RESTv1_1/],
        consumer_key        => $args{consumer_key},
        consumer_secret     => $args{consumer_secret},
        access_token        => $args{access_token},
        access_token_secret => $args{access_token_secret},
    );

    my @twitter_ids = @{ _scroller() };
    my ( $list_id,
         $user_id,
         $u_screen_name,
         $slug ) = $TL->create_list( $nt, $args{listname} );

    $TL->populate_list(
        $nt,
        $list_id,
        $slug,
        $user_id,
        $u_screen_name,
        \@twitter_ids );

    $TL->debug( "...List $slug (id: $list_id) populated successfully!" );
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

1;

