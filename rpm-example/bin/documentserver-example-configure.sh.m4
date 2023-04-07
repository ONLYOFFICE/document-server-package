#!/bin/bash

DIR="/var/www/M4_DS_PREFIX"
LOCAL_CONFIG="/etc/M4_DS_PREFIX/local.json"
EXAMPLE_CONFIG="/etc/M4_DS_PREFIX-example/local.json"
JSON_BIN="$DIR-example/npm/json"
#JSON="$JSON_BIN -I -q -f $LOCAL_CONFIG"
JSON_EXAMPLE="$JSON_BIN -I -q -f $EXAMPLE_CONFIG"

[ $(id -u) -ne 0 ] && { echo "Root privileges required"; exit 1; }

while [ "$1" != "" ]; do
	case $1 in

		-je | --jwtenabled )
			if [ "$2" != "" ]; then
				JWT_ENABLED=$2
				shift
			fi
		;;

		-js | --jwtsecret )
			if [ "$2" != "" ]; then
				JWT_SECRET=$2
				shift
			fi
		;;

		-jh | --jwtheader )
			if [ "$2" != "" ]; then
				JWT_HEADER=$2
				shift
			fi
		;;

		-? | -h | --help )
			echo "  Usage: bash documentserver-example-configure.sh [PARAMETER] [[PARAMETER], ...]"
			echo
			echo "    Parameters:"
			echo "      -je, --jwtenabled            Specifies the enabling the JSON Web Token validation                            ( Defaults to true )"
			echo "      -js, --jwtsecret             Defines the secret key to validate the JSON Web Token in the request            ( Defaults to random secret )"
			echo "      -jh, --jwtheader             Defines the http header that will be used to send the JSON Web Token            ( Defaults to Authorization )"
			echo "      -?, -h, --help               this help"
			echo
			exit 0
		;;

		* )
			echo "Unknown parameter $1" 1>&2
			exit 1
		;;
	esac
	shift
done

# EXAMPLE_PORT=${EXAMPLE_PORT:-3000}

if [ -z $JWT_SECRET ] && [ -z $JWT_ENABLED ]; then
	JWT_MESSAGE="JWT is enabled by default. A random secret is generated automatically."
fi

JWT_ENABLED=${JWT_ENABLED:-true}
JWT_SECRET=${JWT_SECRET:-$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)}
JWT_HEADER=${JWT_HEADER:-Authorization}

create_local_configs(){
	for i in $EXAMPLE_CONFIG; do
		if [ ! -f ${i} ]; then
			install -m 640 -D /dev/null ${i}
			echo {} > ${i}
		fi
  	done
}

tune_local_configs(){
	for i in $EXAMPLE_CONFIG; do
		if [ -f ${i} ]; then
			chown ds:ds -R ${i}
		fi
  	done
}

restart_services() {
	[ -a /etc/nginx/conf.d/default.conf ] && \
	mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.old

	[ -a /etc/nginx/conf.d/onlyoffice-documentserver.conf ] && \
	mv /etc/nginx/conf.d/onlyoffice-documentserver.conf /etc/nginx/conf.d/onlyoffice-documentserver.conf.old

	echo -n "Restarting services... "
	for SVC in ds-example nginx; do
		if [ -e /usr/lib/systemd/system/$SVC.service ]; then
			systemctl restart $SVC 
		fi
	done
	echo "OK"
}

save_jwt_params(){
	if [ -f "${EXAMPLE_CONFIG}" ]; then
		${JSON_EXAMPLE} -e "if(this.server===undefined)this.server={};"
		${JSON_EXAMPLE} -e "if(this.server.token===undefined)this.server.token={};"

		if [ "${JWT_ENABLED}" == "true" -o "${JWT_ENABLED}" == "false" ]; then
			${JSON_EXAMPLE} -e "this.server.token.enable = ${JWT_ENABLED}"
		fi
		${JSON_EXAMPLE} -e "this.server.token.secret = '${JWT_SECRET}'"
		${JSON_EXAMPLE} -e "this.server.token.authorizationHeader = '${JWT_HEADER}'"
	fi
}

setup_nginx(){
  NGINX_CONF_DIR=/etc/M4_DS_PREFIX/nginx
  DS_CONF_TMPL=$NGINX_CONF_DIR/ds.conf.tmpl
  DS_CONF=$NGINX_CONF_DIR/ds.conf

  # check whethere enabled
  shopt -s nocasematch
  PORTS=()
  case $(getenforce) in
    enforcing|permissive)
      PORTS+=('3000')
	  setsebool -P httpd_can_network_connect on
    ;;
    disabled)
      :
    ;;
  esac

  # add selinux extentions
  for PORT in ${PORTS[@]}; do
    semanage port -a -t http_port_t -p tcp $PORT >/dev/null 2>&1 || \
      semanage port -m -t http_port_t -p tcp $PORT >/dev/null 2>&1 || \
      true
  done
}

create_local_configs
save_jwt_params
tune_local_configs
setup_nginx

# generate secure link
#documentserver-update-securelink.sh

restart_services

echo $JWT_MESSAGE
