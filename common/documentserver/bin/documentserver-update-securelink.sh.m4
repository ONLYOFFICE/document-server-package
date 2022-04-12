#!/bin/sh

while [ "$1" != "" ]; do
	case $1 in

		-s | --secret_string )
			if [ "$2" != "" ]; then
				SECURE_LINK_SECRET=$2
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

NGINX_CONF=/etc/M4_DS_PREFIX/nginx/ds.conf
DOCSERVICE_CONF=/etc/M4_DS_PREFIX/default.json
JSON="/var/www/M4_DS_PREFIX/npm/json -q -f ${DOCSERVICE_CONF}"

SECURE_LINK_SECRET=${SECURE_LINK_SECRET:-$(pwgen -s 20)}

sed "s,\(set \+\$secret_string\).*,\1 "${SECURE_LINK_SECRET}";," -i ${NGINX_CONF}
${JSON} -I -e "this.storage.fs.secretString = '${SECURE_LINK_SECRET}'"

[ -x "$(command -v debconf-set-selections)" ] && echo M4_PACKAGE_NAME M4_ONLYOFFICE_VALUE/secure_link_secret string ${SECURE_LINK_SECRET} | debconf-set-selections

supervisorctl restart ds:docservice
supervisorctl restart ds:converter
service nginx reload
