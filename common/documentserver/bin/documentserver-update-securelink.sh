#!/bin/sh

NGINX_CONF=/etc/nginx/includes/onlyoffice-documentserver-docservice.conf
DOCSERVICE_CONF=/etc/onlyoffice/documentserver/default.json
JSON="json -q -f ${DOCSERVICE_CONF}"

SECRET_STRING=$(pwgen -s 20)

sed "s,\(set \+\$secret_string\).*,\1 "${SECRET_STRING}";," -i ${NGINX_CONF}

${JSON} -I -e "this.storage.fs.secretString = '${SECRET_STRING}'"

sudo supervisorctl restart onlyoffice-documentserver:docservice
sudo supervisorctl restart onlyoffice-documentserver:converter
sudo service nginx reload
