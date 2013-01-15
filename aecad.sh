#!/bin/bash

####
#
# elasticache auto-discovery cron - async update of active servers for PHP clients
#
# @see https://github.com/rynop/aecad-for-php
#
# @license      MIT License (http://www.opensource.org/licenses/mit-license.php)
#
####

CONFIGURATION_ENDPOINT="your-cluster-name.1234.cfg.use1.cache.amazonaws.com"
CONFIGURATION_ENDPOINT_PORT="11211"
LOCAL_WS_PORT="49000"

#cluster config output is in the format:
#
#CONFIG cluster 0 146
#1
#<CONFIGURATION_NAME>.blah|10.1.1.1|11211 <CONFIGURATION_NAME>.blah|10.2.2.2|11211

CLUSTER_NAME=`echo $CONFIGURATION_ENDPOINT | cut -d'.' -f 1`
output=`echo 'config get cluster' | nc $CONFIGURATION_ENDPOINT $CONFIGURATION_ENDPOINT_PORT`

QS=""
for server in $output; do 

	echo "$server" | grep "$CLUSTER_NAME" > /dev/null
	if [ $? -eq 0 ]; then

		QS+="server%5B%5D=${server}&"
		#If for some reason you want to pass the parts up to your web service
		#	IFS='|' read -ra PARTS <<< "$server"
		#	server=${PARTS[0]}
		#	ip=${PARTS[1]}
		#	port=${PARTS[2]}
		#	echo ${server}:${port}
	fi
done

if [ -n "$QS" ]; then	
	curl -s "localhost:${LOCAL_WS_PORT}/aecad.php?${QS}"
fi

