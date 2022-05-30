#!/bin/sh

NGINX_CONF=/etc/nginx/includes/ds-docservice.conf
DOCSERVICE_CONF=/etc/M4_DS_PREFIX/default.json
JSON="/var/www/M4_DS_PREFIX/npm/json -q -f ${DOCSERVICE_CONF}"

SECRET_STRING=$(pwgen -s 20)

sed "s,\(set \+\$secret_string\).*,\1 "${SECRET_STRING}";," -i ${NGINX_CONF}

${JSON} -I -e "this.storage.fs.secretString = '${SECRET_STRING}'"

supervisorctl restart ds:docservice
supervisorctl restart ds:converter
service nginx reload
