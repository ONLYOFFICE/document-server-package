#!/bin/bash

NGINX_INCLUDES="/etc/nginx/includes/"
SERVER_URL=http://localhost:8000/healthcheck
TIMER=5

echo "DocumentServer starting up, please wait ..."

while [ $TIMER != 230 ] && [ "$STATUS" != "200" ]
do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}\n" $SERVER_URL)
  TIMER=$(( $TIMER + 5 ))
  sleep 5
done
echo "DocumentServer is ready"

  # back nginx config links to default condition
  rm -f ${NGINX_INCLUDES}ds-0maintenance.conf
  service nginx reload >/dev/null 2>&1
 
exit 0
