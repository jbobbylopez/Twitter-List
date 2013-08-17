#!/usr/bin/env perl

use 5.014;
use lib "../lib";
use lib "lib/";

use Twitter::List::CPANAuthors;

my $listname            = "CPAN Authors";
my $consumer_key        = "xxxxxxxxxxxxxx";
my $consumer_secret     = "xxxxxxxxxxxxxx";
my $access_token        = "xxxxxxxxxxxxxx";
my $access_token_secret = "xxxxxxxxxxxxxx";

my %settings = (
    dbg                 => 0, # (0 or 1), default 0 (slient), shows debug data on STDOUT
    listname            => $listname,
    consumer_key        => $consumer_key,
    consumer_secret     => $consumer_secret,
    access_token        => $access_token,
    access_token_secret => $access_token_secret
);

my $twitter_list = new Twitter::List::CPANAuthors;

$twitter_list->create( %settings );
