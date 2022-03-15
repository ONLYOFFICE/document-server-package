#!/bin/sh

[ $(id -u) -ne 0 ] && { echo "Root privileges required"; exit 1; }

CONF_DIR="/etc/M4_DS_PREFIX"
DIR="/var/www/M4_DS_PREFIX"

LOCAL_CONFIG=${CONF_DIR}/local.json
DEFAULT_CONFIG=${CONF_DIR}/default.json
Configs=($LOCAL_CONFIG $DEFAULT_CONFIG)

JSON_BIN="$DIR/npm/json"

for i in "${!Configs[@]}";
do
	if [ -f ${Configs[$i]} ]; then
		JSON="$JSON_BIN -f ${Configs[$i]}"
		JWT_ENABLED=$($JSON "services.CoAuthoring.token.enable.request.inbox")	
		JWT_SECRET=$($JSON "services.CoAuthoring.secret.inbox.string")
		JWT_HEADER=$($JSON "services.CoAuthoring.token.inbox.header")
		if [ -n "$JWT_ENABLED" ]; then	
			echo "Your JWT settings:"
			echo "JWT enabled -  $JWT_ENABLED"
			if [ $JWT_ENABLED = "true" ]; then
				echo "JWT secret  -  $JWT_SECRET"
				echo "JWT header  -  $JWT_HEADER"		
			fi
			break
		fi
	else
		echo "JWT SECRET validation failed with an error"
		echo "You can reconfigure the package using the command"
		echo "dpkg-reconfigure onlyoffice-documentserver-ee"
	fi
done
#NODE_CONFIG_DIR #NODE_ENV
