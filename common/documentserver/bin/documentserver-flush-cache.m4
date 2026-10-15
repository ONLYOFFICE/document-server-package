#!/bin/sh

while [ "$1" != "" ]; do
	case $1 in

		-h | --hash )
			if [ "$2" != "" ]; then
				HASH=$2
				shift
			fi
		;;

                -r | --restart )
                        if [ "$2" != "" ]; then
                                RESTART_CONDITION=$2
                                shift
                        fi
                ;;

	esac
	shift
done

# Validate the user-supplied hash before it reaches the sed/nginx config.
# HASH ends up in a sed replacement string (sed -i "s/.../${HASH}/g" ...);
# an unrestricted value can break out of the s/// syntax and, combined with
# GNU sed's `e` flag, execute arbitrary shell commands as root (this script
# is invoked via `sudo ... NOPASSWD`). Restrict to a safe, hash/tag-like charset.
# (RESTART_CONDITION is only ever compared with `[ ... != "false" ]` below,
# never interpolated into a command, so it does not need sanitizing.)
case "$HASH" in
	'') ;;
	*[!A-Za-z0-9._-]*)
		echo "documentserver-flush-cache: invalid --hash value '${HASH}': only [A-Za-z0-9._-] characters are allowed" >&2
		exit 1
		;;
esac

HASH=${HASH:-$(date +'%Y.%m.%d-%H%M' | openssl md5 | awk '{print $2}')}

# Save the hash to a variable in the configuration file
echo "set \$cache_tag \"$HASH\";" > /etc/nginx/includes/ds-cache.conf

API_PATH="/var/www/M4_DS_PREFIX/web-apps/apps/api/documents/api.js"
cp -f ${API_PATH}.tpl ${API_PATH}
sed -i "s/{{HASH_POSTFIX}}/${HASH}/g" ${API_PATH}
chown ds:ds ${API_PATH}
rm -f ${API_PATH}.gz

if [ "$RESTART_CONDITION" != "false" ]; then
    if (pgrep -x "systemd" > /dev/null) && systemctl is-active --quiet nginx; then
        systemctl reload nginx
    elif service nginx status > /dev/null 2>&1; then
        service nginx reload
    fi
fi
