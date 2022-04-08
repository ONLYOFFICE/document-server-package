#!/bin/sh

while [ "$1" != "" ]; do
	case $1 in

		-s | --secret_string )
			if [ "$2" != "" ]; then
				SECURE_LINK_SECRET=$(echo "$2" | awk '{print toupper($0)}');
				shift
			fi
		;;

		-? | -h | --help )
			echo "  Usage $0 [PARAMETER] [[PARAMETER], ...]"
			echo "    Parameters:"
			echo "      -s, --secret_string               setting for secret string "
			echo "      -?, -h, --help                    this help"
			echo
			exit 0
		;;

	esac
	shift
done

NGINX_CONF=/etc/nginx/conf.d/ds.conf
DOCSERVICE_CONF=/etc/M4_DS_PREFIX/default.json
JSON="/var/www/M4_DS_PREFIX/npm/json -q -f ${DOCSERVICE_CONF}"

SECURE_LINK_SECRET=${SECURE_LINK_SECRET:-$(pwgen -s 20)}

sed "s,\(set \+\$secret_string\).*,\1 "${SECURE_LINK_SECRET}";," -i ${NGINX_CONF}

${JSON} -I -e "this.storage.fs.secretString = '${SECURE_LINK_SECRET}'"

echo M4_PACKAGE_NAME M4_COMPANY_NAME/secure_link_secret select ${SECURE_LINK_SECRET} | sudo debconf-set-selections

supervisorctl restart ds:docservice
supervisorctl restart ds:converter
service nginx reload
