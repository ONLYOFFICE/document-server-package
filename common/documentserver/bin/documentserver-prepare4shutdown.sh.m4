#!/bin/sh

echo -n Preparing for shutdown, it can take a lot of time, please wait...

curl http://localhost/internal/cluster/inactive -X PUT -s -o /dev/null

echo Done
