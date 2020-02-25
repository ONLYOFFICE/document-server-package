#!/bin/sh

echo -n Preparing for shutdown, it can take a lot of time, please wait...

wget http://localhost/internal/cluster/inactive --method=PUT -q

echo Done
