#!/bin/bash

[ $(id -u) -ne 0 ] && { echo "Root privileges required"; exit 1; }
[ -z "$1" ] && { echo "Parameters haven't been entered"; echo "Use help command: $0 --help"; exit 1; }

PLUGIN_MANAGER="/var/www/M4_DS_PREFIX/server/tools/pluginsmanager"
PLUGIN_DIR="/var/www/M4_DS_PREFIX/sdkjs-plugins/"
MANAGER_WITH_DIRECTORY="${PLUGIN_MANAGER} --directory=\"${PLUGIN_DIR}\""

while [ "$1" != "" ]; do
	case $1 in

		--h | --help | --print-marketplace )
			${PLUGIN_MANAGER} ${1} | sed -e 's_="_ "_g' -e "/--directory/a \ \t \t \t Default is ${PLUGIN_DIR//_/\\_}"
		;;

		--directory )
			if [ "$2" != "" ]; then
				MANAGER_WITH_DIRECTORY="${PLUGIN_MANAGER} ${1}=\"${2}\""
				PLUGIN_DIR=${2}
				shift
			fi
		;;

		--marketplace )
			if [ "$2" != "" ]; then
				MANAGER_WITH_DIRECTORY="${MANAGER_WITH_DIRECTORY} ${1}=\"${2}\""
				shift
			fi
		;;

		--install | --remove | --restore )
			if [ "$2" != "" ]; then
				${MANAGER_WITH_DIRECTORY} ${1}="\"${2}\""
				shift
			fi
		;;

		--print-installed | --print-backup | --remove-all )
			${MANAGER_WITH_DIRECTORY} ${1}
		;;

		-r | --restart )
			if [ "$2" != "" ]; then
				RESTART_CONDITION=$2
				shift
			fi
		;;

		* )
			echo "Unknown parameter ${1}" 1>&2
			echo "Use help command: $0 --help" 1>&2
			exit 1
		;;
	esac
	shift
done

chown -R ds:ds ${PLUGIN_DIR}

if [ "$RESTART_CONDITION" != "false" ]; then
	if pgrep -x ""systemd"" >/dev/null; then
		systemctl restart ds-docservice
	elif pgrep -x ""supervisord"" >/dev/null; then
		supervisorctl restart ds:docservice
	fi
fi
