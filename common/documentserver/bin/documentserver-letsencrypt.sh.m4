#!/bin/bash

LETSENCRYPT_ROOT_DIR="/etc/letsencrypt/live";
ROOT_DIR="M4_DS_ROOT/../Data/le";
NGINX_CONF_DIR="/etc/M4_DS_PREFIX/nginx";

LETS_ENCRYPT_MAIL=none
LETS_ENCRYPT_DOMAIN=none

if [ "$1" != "" ]; then
    LETS_ENCRYPT_MAIL=$1
fi

if [ "$2" != "" ]; then
    LETS_ENCRYPT_DOMAIN=$2
fi

SSL_CERT="${LETSENCRYPT_ROOT_DIR}/${LETS_ENCRYPT_DOMAIN}/fullchain.pem";
SSL_KEY="${LETSENCRYPT_ROOT_DIR}/${LETS_ENCRYPT_DOMAIN}/privkey.pem";

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ${ROOT_DIR}

echo certbot certonly --expand --webroot -w ${ROOT_DIR} --noninteractive --agree-tos --email $LETS_ENCRYPT_MAIL -d $LETS_ENCRYPT_DOMAIN > /var/log/le-start.log

certbot certonly --expand --webroot -w ${ROOT_DIR} --noninteractive --agree-tos --email $LETS_ENCRYPT_MAIL -d $LETS_ENCRYPT_DOMAIN > /var/log/le-new.log

if [ -f ${SSL_CERT} -a -f ${SSL_KEY} ]; then
    cp -f ${NGINX_CONF_DIR}/ds-ssl.conf.tmpl ${NGINX_CONF_DIR}/ds.conf
    sed 's,{{SSL_CERTIFICATE_PATH}},'"${SSL_CERT}"',' -i ${NGINX_CONF_DIR}/ds.conf
    sed 's,{{SSL_KEY_PATH}},'"${SSL_KEY}"',' -i ${NGINX_CONF_DIR}/ds.conf
fi

service nginx reload

cat > ${DIR}/letsencrypt_cron.sh <<END
certbot renew >> /var/log/le-renew.log
service nginx reload
END

chmod a+x ${DIR}/letsencrypt_cron.sh

cat > /etc/cron.d/letsencrypt <<END
@weekly root ${DIR}/letsencrypt_cron.sh
END
