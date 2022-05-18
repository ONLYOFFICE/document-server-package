#!/bin/bash

Timeout=300 # 5 minutes

function timeout_monitor() {
   sleep "$Timeout"
   echo "Timeout: healthcheck didn't passed"
   rm -f ${NGINX_INCLUDES}ds-0maintains.conf
   service nginx reload >/dev/null 2>&1
   kill "$1"
}

# start the timeout monitor in
# background and pass the PID:
timeout_monitor "$$" &
Timeout_monitor_pid=$!

NGINX_INCLUDES="/etc/nginx/includes/"
SERVER_URL=http://localhost:8000/healthcheck
TIMER=5

echo "DocumentServer starting up, please wait while health check passes..."

while [ $TIMER -ne 230 ] && [ "$STATUS" != "200" ]
do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}\n" $SERVER_URL)
  TIMER=$(( $TIMER + 5 ))
  sleep 5
done
echo "Healthcheck passed, DocumentServer is up and ready"

  # back nginx config links to default condition
  rm -f ${NGINX_INCLUDES}ds-0maintains.conf
  service nginx reload >/dev/null 2>&1
 
  # kill timeout monitor when terminating:
  kill "$Timeout_monitor_pid"

exit 0
