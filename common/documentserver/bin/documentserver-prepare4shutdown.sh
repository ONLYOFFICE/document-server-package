#!/bin/sh
APP_DIR=/var/www/onlyoffice/documentserver

sudo \
  NODE_ENV=production-linux \
  NODE_CONFIG_DIR=/etc/onlyoffice/documentserver \
  -u onlyoffice node $APP_DIR/server/DocService/sources/shutdown.js

