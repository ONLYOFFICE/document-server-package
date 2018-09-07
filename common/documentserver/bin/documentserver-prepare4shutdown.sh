#!/bin/sh

echo Preparing for shutdown, it can take a lot of time, please wait...

sudo -u onlyoffice \
  sh -c '\
    NODE_ENV=production-linux \
    NODE_CONFIG_DIR=/etc/onlyoffice/documentserver \
    node /var/www/onlyoffice/documentserver/server/DocService/sources/shutdown.js'

echo Done
