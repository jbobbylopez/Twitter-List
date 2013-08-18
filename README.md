### Twitter::List

#### Summary

Provided a set of Twitter API keys, a list name, and a list of Twitter IDs, Twitter::List will create a new Twitter List on Twitter.

#### Synopsis

```
use 5.14;
use strict;
use warnings;
use Twitter::List;

my $listname = "My New List";
my $consumer_key        = "xxxxxxxxxxxxxx";
my $consumer_secret     = "xxxxxxxxxxxxxx";
my $access_token        = "xxxxxxxxxxxxxx";
my $access_token_secret = "xxxxxxxxxxxxxx";

my @twitter_ids = ( 'marym', 'joej', 'jimj', 'johnj' );

my %settings = ( 
     consumer_key            => $consumer_key,
     consumer_secret         => $consumer_secret,
     access_token            => $access_token,
     access_token_secret     => $access_token_secret
);

my $TWL = Twitter::List->new( %settings );
$TWL->set_debug( 0 ); # (0|1), 1 default (enabled), shows debug data on STDOUT

my %list_details = $TWL->create_list( $listname );
     
$TWL->populate_list( \%list_details, \@twitter_ids );
    
$TWL->set_debug( 1 );
$TWL->debug( "...List $list_details{slug} (id: $list_details{list_id}) populated successfully!" );
```

#### Description

Twitter::List provides the ability to easily create Twitter lists and populate them with a list of Twitter usernames.

#### Twitter::List Examples

##### Twitter::List::CPANAuthors

A list creation library called Twitter::List::CPANAuthors is also
provided as an example of one way to write a custom list generator module.

There is also a sample caller script (bin/app-example.pl) which makes use of
Twitter::List::CPANAuthors to create a List on Twitter, and populate it with
the Twitter IDs of all the CPAN authors using data from the MetaCPAN API.


#### Warning

Whenever you add a user to a Twitter List, that user may be
notified that they have been added to a list.  If you use this module
often with the same usernames, you may annoy some people.  You have been warned.

#### Author
J. Bobby Lopez - http://www.jbldata.com
