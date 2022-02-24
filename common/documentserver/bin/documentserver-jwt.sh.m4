#!/bin/sh

CONF_DIR="/etc/onlyoffice/documentserver"
DIR="/var/www/onlyoffice/documentserver"

LOCAL_CONFIG=${CONF_DIR}/local.json
DEFAULT_CONFIG=${CONF_DIR}/default.json

JSON_BIN="$DIR/npm/json"

read_jwt_params(){
	JWT_ENABLED=$($JSON "services.CoAuthoring.token.enable.request.inbox")	
	JWT_SECRET=$($JSON "services.CoAuthoring.secret.inbox.string")
	JWT_HEADER=$($JSON "services.CoAuthoring.token.inbox.header")
}

output_jwt_params(){
	echo "Your JWT settings:"
	echo "JWT enabled -  $JWT_ENABLED"
	if [ $JWT_ENABLED = "true" ]; then
		echo "JWT secret  -  $JWT_SECRET"
		echo "JWT header  -  $JWT_HEADER"		
	fi
}

if [ -f $LOCAL_CONFIG ]; then
	JSON="$JSON_BIN -f $LOCAL_CONFIG"
	read_jwt_params
	output_jwt_params
elif [ -f $DEFAULT_CONFIG ]; then
	JSON="$JSON_BIN -f $DEFAULT_CONFIG"
	read_jwt_params
	output_jwt_params
else
	echo "JWT SECRET validation failed with an error"
	echo "You can reconfigure the package using the command"
	echo "dpkg-reconfigure onlyoffice-documentserver-ee"
fi
