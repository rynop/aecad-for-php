# Alternative ElastiCache auto-discovery for PHP

This is an alternative to using AWS ElastiCache Cluster Client for PHP.  For a [bunch of reasons](https://forums.aws.amazon.com/thread.jspa?messageID=414605), mainly because I wanted to be in control of my memcached lib, I did not want to use the AWS EC client for PHP.

This is an alternative method, that gives the same result - your code gracefully handles ElastiCache cluster with very minimal change.

This project leverages the AWS memcached [config](http://docs.amazonwebservices.com/AmazonElastiCache/latest/UserGuide/AutoDiscovery.ConfigCommand.html) extension to the ascii protocol, as well as [APC](http://php.net/manual/en/book.apc.php).

## Requirements

1. [PECL memcached](http://pecl.php.net/package/memcached) (Recommended) or [PECL memcache](http://pecl.php.net/package/memcache)
2. [APC](http://php.net/manual/en/book.apc.php)
3. A webserver that runs on localhost. nginx example in this repo.

## Installation

1. 
