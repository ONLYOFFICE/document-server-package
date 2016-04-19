#!/bin/sh
APP_DIR="/var/www/onlyoffice/documentserver"

NODE_ENV=production-linux
NODE_CONFIG_DIR=/etc/onlyoffice/documentserver

sudo -u onlyoffice node "$APP_DIR/server/DocService/sources/shutdown.js"
