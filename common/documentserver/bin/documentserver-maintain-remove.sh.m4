#!/bin/bash
  
NGINX_INCLUDES="/etc/nginx/includes/"
ONLYOFFICE_INCLUDES="/etc/onlyoffice/documentserver-example/nginx/includes/"
SERVER_URL=http://localhost:8000/healthcheck

while [ "$STATUS" != "200" ]
do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}\n" $SERVER_URL)
  sleep 10
done
echo DocumentServer is up

  # back nginx config links to default condition
  rm -f ${NGINX_INCLUDES}ds-0maintain.conf
  service nginx restart >/dev/null 2>&1

exit 0

