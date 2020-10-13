#!/bin/bash

LETSENCRYPT_ROOT_DIR="/etc/letsencrypt/live";
ROOT_DIR="M4_DS_ROOT/../Data/certs";

LETS_ENCRYPT_MAIL=none
LETS_ENCRYPT_DOMAIN=none

if [ "$1" != "" ]; then
    LETS_ENCRYPT_MAIL=$1
fi

if [ "$2" != "" ]; then
    LETS_ENCRYPT_DOMAIN=$2
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ${ROOT_DIR}

echo certbot certonly --expand --webroot -w ${ROOT_DIR} --noninteractive --agree-tos --email $LETS_ENCRYPT_MAIL -d $LETS_ENCRYPT_DOMAIN > /var/log/le-start.log

certbot certonly --expand --webroot -w ${ROOT_DIR} --noninteractive --agree-tos --email $LETS_ENCRYPT_MAIL -d $LETS_ENCRYPT_DOMAIN > /var/log/le-new.log

cp ${LETSENCRYPT_ROOT_DIR}/${LETS_ENCRYPT_DOMAIN}/fullchain.pem ${ROOT_DIR}/onlyoffice.crt
cp ${LETSENCRYPT_ROOT_DIR}/${LETS_ENCRYPT_DOMAIN}/privkey.pem ${ROOT_DIR}/onlyoffice.key
cp ${LETSENCRYPT_ROOT_DIR}/${LETS_ENCRYPT_DOMAIN}/chain.pem ${ROOT_DIR}/stapling.trusted.crt

cat > ${DIR}/letsencrypt_cron.sh <<END
certbot renew >> /var/log/le-renew.log
cp ${LETSENCRYPT_ROOT_DIR}/${LETS_ENCRYPT_DOMAIN}/fullchain.pem ${ROOT_DIR}/onlyoffice.crt
cp ${LETSENCRYPT_ROOT_DIR}/${LETS_ENCRYPT_DOMAIN}/privkey.pem ${ROOT_DIR}/onlyoffice.key
cp ${LETSENCRYPT_ROOT_DIR}/${LETS_ENCRYPT_DOMAIN}/chain.pem ${ROOT_DIR}/stapling.trusted.crt
service nginx reload
END

chmod a+x ${DIR}/letsencrypt_cron.sh

cat > /etc/cron.d/letsencrypt <<END
@weekly root ${DIR}/letsencrypt_cron.sh
END
