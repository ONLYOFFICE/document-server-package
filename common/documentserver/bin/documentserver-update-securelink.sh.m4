#!/bin/sh

while [ "$1" != "" ]; do
	case $1 in

		-s | --secure_link_secret )
			if [ "$2" != "" ]; then
				SECURE_LINK_SECRET=$2
				shift
			fi
		;;

                -r | --restart )
                        if [ "$2" != "" ]; then
                                ONLYOFFICE_DATA_CONTAINER=$2
                                shift
                        fi
                ;;


		-? | -h | --help )
			echo "  Usage $0 [PARAMETER] [[PARAMETER], ...]"
			echo "    Parameters:"
			echo "      -s, --secure_link_secret               setting for secret string "
			echo "      -?, -h, --help                    this help"
			echo
			exit 0
		;;

	esac
	shift
done

NGINX_CONF=/etc/M4_DS_PREFIX/nginx/ds.conf
LOCAL_CONF=/etc/M4_DS_PREFIX/local.json
JSON="/var/www/M4_DS_PREFIX/npm/json -q -f ${LOCAL_CONF}"

SECURE_LINK_SECRET=${SECURE_LINK_SECRET:-$(pwgen -s 20)}

sed "s,\(set \+\$secure_link_secret\).*,\1 "${SECURE_LINK_SECRET}";," -i ${NGINX_CONF}
${JSON} -I -e 'this.storage={fs: {secretString: "'${SECURE_LINK_SECRET}'" }}' && chown ds:ds $LOCAL_CONF

if [ "$ONLYOFFICE_DATA_CONTAINER" != "false" ]; then
   supervisorctl restart ds:docservice
   supervisorctl restart ds:converter
fi

service nginx reload
