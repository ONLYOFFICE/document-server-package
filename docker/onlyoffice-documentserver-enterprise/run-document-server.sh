#!/bin/bash

DATA_DIR="/var/www/onlyoffice/Data"
LOG_DIR="/var/log/onlyoffice"

ONLYOFFICE_HTTPS=${ONLYOFFICE_HTTPS:-false}

SSL_CERTIFICATES_DIR="${DATA_DIR}/certs"
SSL_CERTIFICATE_PATH=${SSL_CERTIFICATE_PATH:-${SSL_CERTIFICATES_DIR}/onlyoffice.crt}
SSL_KEY_PATH=${SSL_KEY_PATH:-${SSL_CERTIFICATES_DIR}/onlyoffice.key}
CA_CERTIFICATES_PATH=${CA_CERTIFICATES_PATH:-${SSL_CERTIFICATES_DIR}/ca-certificates.pem}
SSL_DHPARAM_PATH=${SSL_DHPARAM_PATH:-${SSL_CERTIFICATES_DIR}/dhparam.pem}
SSL_VERIFY_CLIENT=${SSL_VERIFY_CLIENT:-off}
ONLYOFFICE_HTTPS_HSTS_ENABLED=${ONLYOFFICE_HTTPS_HSTS_ENABLED:-true}
ONLYOFFICE_HTTPS_HSTS_MAXAGE=${ONLYOFFICE_HTTPS_HSTS_MAXAG:-31536000}
SYSCONF_TEMPLATES_DIR="/app/onlyoffice/setup/config"

NGINX_ONLYOFFICE_PATH="/etc/nginx/conf.d/onlyoffice-documentserver.conf";

# create base folders
mkdir -p /var/log/onlyoffice/documentserver/converter/
mkdir -p /var/log/onlyoffice/documentserver/docservice/
mkdir -p /var/log/onlyoffice/documentserver/example/
mkdir -p /var/log/onlyoffice/documentserver/spellchecker/
mkdir -p /var/log/onlyoffice/documentserver/metrics/

# setup HTTPS
if [ -f "${SSL_CERTIFICATE_PATH}" -a -f "${SSL_KEY_PATH}" ]; then
        cp ${SYSCONF_TEMPLATES_DIR}/nginx/onlyoffice-ssl ${NGINX_ONLYOFFICE_PATH}

        mkdir ${DATA_DIR}
        mkdir ${LOG_DIR}/nginx

        # configure nginx
        sed 's,{{SSL_CERTIFICATE_PATH}},'"${SSL_CERTIFICATE_PATH}"',' -i ${NGINX_ONLYOFFICE_PATH}
        sed 's,{{SSL_KEY_PATH}},'"${SSL_KEY_PATH}"',' -i ${NGINX_ONLYOFFICE_PATH}

        # if dhparam path is valid, add to the config, otherwise remove the option
        if [ -r "${SSL_DHPARAM_PATH}" ]; then
          sed 's,{{SSL_DHPARAM_PATH}},'"${SSL_DHPARAM_PATH}"',' -i ${NGINX_ONLYOFFICE_PATH}
        else
          sed '/ssl_dhparam {{SSL_DHPARAM_PATH}};/d' -i ${NGINX_ONLYOFFICE_PATH}
        fi

        sed 's,{{SSL_VERIFY_CLIENT}},'"${SSL_VERIFY_CLIENT}"',' -i ${NGINX_ONLYOFFICE_PATH}

        if [ -f "${CA_CERTIFICATES_PATH}" ]; then
          sed 's,{{CA_CERTIFICATES_PATH}},'"${CA_CERTIFICATES_PATH}"',' -i ${NGINX_ONLYOFFICE_PATH}
        else
          sed '/{{CA_CERTIFICATES_PATH}}/d' -i ${NGINX_ONLYOFFICE_PATH}
        fi

        if [ "${ONLYOFFICE_HTTPS_HSTS_ENABLED}" == "true" ]; then
          sed 's/{{ONLYOFFICE_HTTPS_HSTS_MAXAGE}}/'"${ONLYOFFICE_HTTPS_HSTS_MAXAGE}"'/' -i ${NGINX_ONLYOFFICE_PATH}
        else
          sed '/{{ONLYOFFICE_HTTPS_HSTS_MAXAGE}}/d' -i ${NGINX_ONLYOFFICE_PATH}
        fi
fi

# Regenerate the fonts list and the fonts thumbnails
/var/www/onlyoffice/documentserver/Tools/GenerateAllFonts.sh

service mysql start
service nginx start
service redis-server start
service rabbitmq-server start
service supervisor start
