#!/bin/sh
APP_DIR=/var/www/onlyoffice/documentserver

echo -n Preparing for shutdown, it can take a lot of time, please wait...

sudo \
  NODE_ENV=production-linux \
  NODE_CONFIG_DIR=/etc/onlyoffice/documentserver \
  -u onlyoffice node $APP_DIR/server/DocService/sources/shutdown.js

echo Done
