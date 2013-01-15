# Alternative ElastiCache auto-discovery for PHP

This is an alternative to using AWS ElastiCache Cluster Client for PHP.  For a [bunch of reasons](https://forums.aws.amazon.com/thread.jspa?messageID=414605), mainly because I wanted to be in control of my memcached lib, I did not want to use the AWS EC client for PHP.

This is an alternative method, that gives the same result - your code gracefully handles ElastiCache cluster with very minimal change.

This project leverages the AWS memcached [config](http://docs.amazonwebservices.com/AmazonElastiCache/latest/UserGuide/AutoDiscovery.ConfigCommand.html) extension to the ascii protocol, as well as [APC](http://php.net/manual/en/book.apc.php).  In short, a cron gets the list every minute and hits a php running on localhost to update an APC key with the list of servers.

## Requirements

1. [PECL memcached](http://pecl.php.net/package/memcached) (Recommended) or [PECL memcache](http://pecl.php.net/package/memcache)
2. [APC](http://php.net/manual/en/book.apc.php)
3. A webserver that listens on <code>127.0.0.1</code>. nginx example in this repo.

## Installation

1. put nginx.conf in <code>sudo cp nginx.conf /etc/nginx/sites-enabled/aecad.conf</code>
2. make a webroot and put aecad.php in it <code>sudo mkdir -p /opt/webtools && sudo cp aecad.php /opt/webtools && sudo chown -R www-data /opt/webtools && sudo chmod 600 /opt/webtools/aecad.php</code> 
3. copy <code>aecad.sh</code> to <code>/opt/webtools</code> the edit to set <code>CLUSTER_NAME</code>, <code>CONFIGURATION_ENDPOINT</code> and <code>CONFIGURATION_ENDPOINT_PORT</code>
4. restart nginx <code>sudo /etc/init.d/nginx restart</code>
4. make cron: <code>sudo cp aecad.cron /etc/cron.d/aecad && sudo chown root:root /etc/cron.d/aecad</code>
3. optionally edit aecad.php and change the APC key used to store the servers.

## Setup your code to leverage aecad

Setup your code to use the list of servers in your cluster - will fall back to this by default. If you add servers to the cluster remember to update your code.

The list of servers will be in an array, formatted for [Memcached::addServers()](http://php.net/manual/en/memcached.addservers.php) in the APC key <code>KEYNAME</code> as defined in aecad.php.  If this key is set, you will use the data in it, if not fall back to your hard coded list of servers.

## Example

This example is using [PECL memcached](http://pecl.php.net/package/memcached)

```php
<?php
$m = new Memcached();

if(!($servers = apc_fetch("ec_servers"))){
  //Update this list and re-deploy your code if you ever add/remove servers from your cluster
  $servers = array(
      array('my-cluster-name.abcd.0001.use1.cache.amazonaws.com', 11211, 100),
      array('my-cluster-name.abcd.0002.use1.cache.amazonaws.com', 11211, 100)
  );
}
$m->addServers($servers);

```

The APC key will only be updated if it has changed.

To test things are working you can var_export() the APC key from your app.
