#!/bin/bash

[ $(id -u) -ne 0 ] && { echo "Root privileges required"; exit 1; }

while [ "$1" != "" ]; do
	case $1 in

		-r | --restart )
			if [ "$2" != "" ]; then
				RESTART_CONDITION=$2
				shift
			fi
		;;

		-p | --postinst )
			if [ "$2" != "" ]; then
				POSTINST_CONDITION=$2
				shift
			fi
		;;
		
		* ) args+=("$1");
	esac
	shift
done

PLUGIN_MANAGER="/var/www/M4_DS_PREFIX/server/tools/pluginsmanager"
PLUGIN_DIR="/var/www/M4_DS_PREFIX/sdkjs-plugins/"
MANAGER_WITH_DIRECTORY="${PLUGIN_MANAGER} --directory=\"${PLUGIN_DIR}\""

${MANAGER_WITH_DIRECTORY} "${args[@]}"

DS_PLUGIN_INSTALLATION=${DS_PLUGIN_INSTALLATION:-M4_DS_PLUGIN_INSTALLATION}
if [ "$POSTINST_CONDITION" = "true" ]; then
	if [ "$DS_PLUGIN_INSTALLATION" = "true" ]; then
		PLUGINS_LIST=("highlight code" "macros" "mendeley" "ocr" "photo editor" "speech" "thesaurus" "translator" "youtube" "zotero")
		INSTALLED_PLUGINS=$(${MANAGER_WITH_DIRECTORY} -r false --print-installed)
		for PLUGIN in "${PLUGINS_LIST[@]}"; do
			!(grep -q "$PLUGIN" <<< "$INSTALLED_PLUGINS") && PLUGIN_INSTALL_LIST+=("$PLUGIN")
		done
		if grep -cq "{" <<< "$INSTALLED_PLUGINS"; then 
			echo -n Update plugins, please wait...
			${MANAGER_WITH_DIRECTORY} -r false --update-all >/dev/null
			echo Done
		fi
		if [ ${#PLUGIN_INSTALL_LIST[@]} -gt 0 ]; then
			echo -n Install plugins, please wait...
			${MANAGER_WITH_DIRECTORY} -r false --install="$(printf "%s," "${PLUGIN_INSTALL_LIST[@]}")" >/dev/null
			echo Done
		fi
	fi
fi

chown -R ds:ds "${PLUGIN_DIR}"

if [ "$RESTART_CONDITION" != "false" ]; then
	if pgrep -x ""systemd"" >/dev/null; then
		systemctl restart ds-docservice
	elif pgrep -x ""supervisord"" >/dev/null; then
		supervisorctl restart ds:docservice
	fi
fi
