#!/bin/bash

DIR="/var/www/onlyoffice/documentserver"
NGINX_ONLYOFFICE_PATH="/etc/onlyoffice/documentserver/nginx"

cd ${DIR}
# Make gziped scripts
find ./sdkjs ./web-apps ./sdkjs-plugins ./fonts -type f \( -name *.js* -o -name *.htm* -o -name *.css -o -name *.tt* \) -exec gzip -kf9 {} \;

# Turn on static gzip for nginx
sed '/expires .*;/a   gzip_static on;' \
  -i ${NGINX_ONLYOFFICE_PATH}/includes/onlyoffice-documentserver-docservice.conf

# Reload nginx config
sudo service nginx reload
