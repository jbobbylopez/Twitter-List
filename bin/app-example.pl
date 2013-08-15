#!/usr/bin/env perl

use 5.014;
use lib "../lib";
use lib "lib/";

use Twitter::List::CPANAuthors;


my $listname = "CPAN Authors";

my %settings = (
    listname            => $listname,
    consumer_key        => '5BxVApzxce9UadMS0cwJ5g',
    consumer_secret     => 'CETd0pnokcfOChMOksOgbgHgfmCGKOlFgxX4pSglGQ',
    access_token        => '15050103-yxGtb6Yhv4YIrOeQaY8OD6B1QTKfsjzbKAZsQIkI',
    access_token_secret => 'Bw4iCXJJJohoywphIxWuFzvVH0MAufnr42U2cBntOY'
);

my $twitter_list = new Twitter::List::Create::CPANAuthors;
$twitter_list->create( %settings );

