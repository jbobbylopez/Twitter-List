package Twitter::List::CPANAuthors;
use base ('Twitter::List');

use 5.014;
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
    
    my $TL = Twitter::List->new( %args );

    $TL->set_debug( $args{dbg} );

    my @twitter_ids = @{ _scroller() };
    my %list_details = $TL->create_list( $args{listname} );

    $TL->populate_list( \%list_details, \@twitter_ids );

    $TL->debug( "...List $list_details{slug} (id: $list_details{list_id} ) populated successfully!" );
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

