#!/bin/sh

echo -n Preparing for shutdown, it can take a lot of time, please wait...

sudo -u onlyoffice \
  sh -c '\
    NODE_ENV=production-linux \
    NODE_CONFIG_DIR=/etc/M4_DS_PREFIX \
    node /var/www/M4_DS_PREFIX/server/DocService/sources/shutdown.js'

echo Done
