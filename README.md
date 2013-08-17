### Twitter::List::CPANAuthors

##### Summary

Provided a set of Twitter API keys, Twitter::List::CPANAuthors will create a new Twitter List of CPAN authors based on data from MetaCPAN.

##### Synopsis

```
use 5.14;
use Twitter::List::CPANAuthors;

my $listname = "CPAN Authors";

my $settings = {
	dbg						=> 1 # (0|1), 0 default (silent), shows debug data on STDOUT
	listname 				=> $listname, 
	consumer_key        	=> $consumer_key,
	consumer_secret     	=> $consumer_secret,
	access_token        	=> $token,
	access_token_secret 	=> $token_secret
};
my $twitter_list = new Twitter::List::CPANAuthors->create( %settings );
```

##### Description

Twitter::List::CPANAuthors provides the ability to easily create a new Twitter list and have it populated with a list of Twitter usernames associated with CPAN authors based on data pulled from MetaCPAN.

##### Warning

Whenever you add a user to a Twitter List, that user is
notified that they have been added to a list.  If you use this module
often, you are likely to annoy some of the CPAN authors.  You have been warned.

##### Author
J. Bobby Lopez - http://www.jbldata.com
