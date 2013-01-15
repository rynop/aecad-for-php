<?php

/**
*
* elasticache auto-discovery cron - async update of active servers for PHP clients
*
* @see https://github.com/rynop/aecad-for-php
*
* @license      MIT License (http://www.opensource.org/licenses/mit-license.php)
*
**/

/**
* Params:
* server[]=dns.name|10.2.2.2|11211
**/
define("KEYNAME", "ec_servers");

if(empty($_GET['server'])) {
	echo "no servers";
	exit();
}

//Put servers in format for PECL memcached addServers: http://php.net/manual/en/memcached.addservers.php
$ecServers = array();
foreach($_GET['server'] as $server){
	$pieces = explode('|', $server,3);
	$ecServers[] = array($pieces[1],$pieces[2],100);
}

if(!empty($ecServers)) {
	//Only update on change
	$existing = apc_fetch(KEYNAME);
	if(empty($existing) || $existing != $ecServers){
		apc_store(KEYNAME,$ecServers);
	}
}

/** for debug
$s = apc_fetch(KEYNAME);
var_export($s);
**/
