#!/bin/bash

Timeout=300 # Seconds

# this block will be activated after 5 minutes 
# only if main script didn't exit with 0.
function timeout_monitor() {
   sleep "$Timeout"
   echo "Timeout: healthcheck didn't passed"
   rm -f ${NGINX_INCLUDES}ds-0maintenance.conf
   service nginx reload >/dev/null 2>&1
   kill "$1"
}

# start the timeout monitor in
# background and pass the PID:
timeout_monitor "$$" &
Timeout_monitor_pid=$!

NGINX_INCLUDES="/etc/nginx/includes/"
SERVER_URL=http://localhost:8000/healthcheck
COUNT=5

echo "DocumentServer starting up, please wait ..."

while [ $COUNT != 230 ] && [ "$STATUS" != "200" ]
do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}\n" $SERVER_URL)
  COUNT=$(( $COUNT + 5 ))
  sleep 5
done

  # back nginx config links to default condition
  rm -f ${NGINX_INCLUDES}ds-0maintenance.conf
  service nginx reload >/dev/null 2>&1
 
  # kill timeout monitor when terminating:
  kill "$Timeout_monitor_pid"

exit 0
