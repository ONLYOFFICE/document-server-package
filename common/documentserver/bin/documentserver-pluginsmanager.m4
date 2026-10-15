#!/bin/bash

[ $(id -u) -ne 0 ] && [ $(id -u) -ne 101 ]  && { echo "Root or UID 101 privileges required"; exit 1; }

while [ "$1" != "" ]; do
	case $1 in

		-r | --restart )
			if [ "$2" != "" ]; then
				RESTART_CONDITION=$2
				shift
			fi
		;;

		-k | --k8s )
			if [ "$2" != "" ]; then
				K8S_CONTAINER=$2
				shift
			fi
		;;
		
		* ) args+=("$1");
	esac
	shift
done

export LD_LIBRARY_PATH=/var/www/M4_DS_PREFIX/server/FileConverter/bin:$LD_LIBRARY_PATH

PLUGIN_MANAGER="/var/www/M4_DS_PREFIX/server/tools/pluginsmanager"
PLUGIN_DIR="/var/www/M4_DS_PREFIX/sdkjs-plugins/"

"${PLUGIN_MANAGER}" --directory=\"${PLUGIN_DIR}\" "${args[@]}"

if [ "${K8S_CONTAINER}" != "true" ]; then
  chown -R ds:ds "${PLUGIN_DIR}"
fi

if [ "$RESTART_CONDITION" != "false" ]; then
	if pgrep -x ""systemd"" >/dev/null; then
		systemctl restart ds-docservice
	elif pgrep -x ""supervisord"" >/dev/null; then
		supervisorctl restart ds:docservice
	fi
	documentserver-flush-cache
fi
