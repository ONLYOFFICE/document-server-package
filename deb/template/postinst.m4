#!/bin/bash
# postinst script for M4_ONLYOFFICE_VALUE
#
# see: dh_installdeb(1)

set -e

# summary of how this script can be called:
#        * <postinst> `configure' <most-recently-configured-version>
#        * <old-postinst> `abort-upgrade' <new version>
#        * <conflictor's-postinst> `abort-remove' `in-favour' <package>
#          <new-version>
#        * <postinst> `abort-remove'
#        * <deconfigured's-postinst> `abort-deconfigure' `in-favour'
#          <failed-install-package> <version> `removing'
#          <conflicting-package> <version>
# for details, see http://www.debian.org/doc/debian-policy/ or
# the debian-policy package

. /usr/share/debconf/confmodule

DIR="/var/www/M4_DS_PREFIX"
LOG_DIR="/var/log/M4_DS_PREFIX"
APP_DIR="/var/lib/M4_DS_PREFIX"
CONF_DIR="/etc/M4_DS_PREFIX"
LOCAL_CONFIG=${CONF_DIR}/local.json
EXAMPLE_CONFIG=${CONF_DIR}-example/local.json
JSON_BIN="$DIR/npm/json"
JSON="$JSON_BIN -I -q -f $LOCAL_CONFIG"
JSON_EXAMPLE="$JSON_BIN -I -q -f ${EXAMPLE_CONFIG}"

OLD_VERSION="$2"

DB_TYPE=""
DB_HOST=""
DB_PORT=""
DB_USER=""
DB_PWD=""
DB_NAME=""

RABBITMQ_PROTO=""
RABBITMQ_HOST=""
RABBITMQ_USER=""
RABBITMQ_PWD=""

REDIS_HOST=""

CLUSTER_MODE=""

create_local_configs(){
	for i in $LOCAL_CONFIG $EXAMPLE_CONFIG; do
		if [ -d $(dirname ${i}) -a ! -f ${i} ]; then
			echo {} > ${i}
		fi
  	done
}

read_saved_params(){
	db_get M4_ONLYOFFICE_VALUE/db-type || true
	DB_TYPE="$RET"
	db_get M4_ONLYOFFICE_VALUE/db-host || true
	DB_HOST="$RET"
	db_get M4_ONLYOFFICE_VALUE/db-port || true
	DB_PORT="$RET"
	db_get M4_ONLYOFFICE_VALUE/db-user || true
	DB_USER="$RET"
	db_get M4_ONLYOFFICE_VALUE/db-pwd || true
	DB_PWD="$RET"
	db_get M4_ONLYOFFICE_VALUE/db-name || true
	DB_NAME="$RET"

	db_get M4_ONLYOFFICE_VALUE/rabbitmq-proto || true
	RABBITMQ_PROTO="$RET"
	db_get M4_ONLYOFFICE_VALUE/rabbitmq-host || true
	RABBITMQ_HOST="$RET"
	db_get M4_ONLYOFFICE_VALUE/rabbitmq-user || true
	RABBITMQ_USER="$RET"
	db_get M4_ONLYOFFICE_VALUE/rabbitmq-pwd || true
	RABBITMQ_PWD="$RET"

ifelse(eval(ifelse(M4_PRODUCT_NAME,documentserver-ee,1,0)||ifelse(M4_PRODUCT_NAME,documentserver-ie,1,0)||ifelse(M4_PRODUCT_NAME,documentserver-de,1,0)),1,
`	db_get M4_ONLYOFFICE_VALUE/redis-host || true
	REDIS_HOST="$RET"

',)dnl
	db_get M4_ONLYOFFICE_VALUE/cluster-mode || true
	CLUSTER_MODE="$RET"

	db_get M4_ONLYOFFICE_VALUE/jwt-enabled || true
	JWT_ENABLED="$RET"
	db_get M4_ONLYOFFICE_VALUE/jwt-secret || true
	JWT_SECRET="${RET//select }"
	db_get M4_ONLYOFFICE_VALUE/jwt-header || true
	JWT_HEADER="$RET"

	if [ $JWT_ENABLED = "true" ] && [ -z $JWT_SECRET ]; then
		JWT_MESSAGE="JWT is enabled by default. A random secret is generated automatically. Run the command '# documentserver-jwt-status.sh' to get information about JWT."
		JWT_SECRET=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)
		db_set M4_ONLYOFFICE_VALUE/jwt-secret $JWT_SECRET || true
	elif [ $JWT_ENABLED = "false" ]; then
		JWT_MESSAGE="You have JWT disabled. We recommend enabling JWT in ${LOCAL_CONFIG} in services.CoAuthoring.token.enable and configure your custom JWT key in services.CoAuthoring.secret"
	fi

	db_get M4_ONLYOFFICE_VALUE/plugins-enabled || true
	DS_PLUGIN_INSTALLATION=${DS_PLUGIN_INSTALLATION:-$RET}

	db_get M4_ONLYOFFICE_VALUE/wopi-enabled || true
	WOPI_ENABLED="$RET"
}

install_db() {
	if [ -z $DB_TYPE ]; then
		if dpkg -l | grep -q postgresql-client; then
			DB_TYPE="postgres"
		elif dpkg -l | grep -q mysql-client || dpkg -l | grep -q mysql-community-client; then
			DB_TYPE="mysql"
		elif dpkg -l | grep -q mariadb-client; then
			DB_TYPE="mariadb"
		fi

		db_set M4_ONLYOFFICE_VALUE/db-type $DB_TYPE || true
	fi

	case $DB_TYPE in
		"postgres")
			install_postges
			;;
		"mariadb"|"mysql")
			install_mysql
			;;
		*)
			echo "ERROR: unknown database type"
			exit 1
			;;
	esac
}

install_postges() {
	if [ -n "$DB_PWD" ]; then
		export PGPASSWORD="$DB_PWD"
	fi
	PSQL="psql -q -h$DB_HOST -p${DB_PORT:="5432"} -d$DB_NAME -U$DB_USER -w"
	# test postgresql connection
	set +e
		$PSQL -c ";" &>/dev/null
		ERRCODE=$?
		if [ $ERRCODE -ne 0 ]; then
			service postgresql start &>/dev/null
			$PSQL -c ";" &>/dev/null || \
				{ echo "ERROR: can't connect to postgressql database"; exit 1; }
		fi
	set -e
		if [ ! $CLUSTER_MODE = true ]; then
			$PSQL -f "$DIR/server/schema/postgresql/removetbl.sql" \
				>/dev/null 2>&1
		fi
		$PSQL -f "$DIR/server/schema/postgresql/createdb.sql" \
			>/dev/null 2>&1
}

install_mysql() {
	CONNECTION_PARAMS="-h$DB_HOST -P${DB_PORT:="3306"} -u$DB_USER -p$DB_PWD -w"
	MYSQL="mysql -q $CONNECTION_PARAMS"
	# test mysql connection
	set +e
		$MYSQL -e ";" &>/dev/null
		ERRCODE=$?
		if [ $ERRCODE -ne 0 ]; then
			service mysql start &>/dev/null
			$MYSQL -e ";" &>/dev/null || \
				{ echo "ERROR: can't connect to mysql database"; exit 1; }
		fi
	set -e
		if ! $MYSQL -e "SHOW DATABASES;" | cut -d\| -f 1 | grep -qw $DB_NAME; then
			$MYSQL -e \
				"CREATE DATABASE IF NOT EXISTS $DB_NAME \
				DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;" \
				>/dev/null 2>&1
		fi
		if [ ! $CLUSTER_MODE = true ]; then
			$MYSQL $DB_NAME < "$DIR/server/schema/mysql/removetbl.sql" >/dev/null 2>&1
		fi
		$MYSQL $DB_NAME < "$DIR/server/schema/mysql/createdb.sql" >/dev/null 2>&1
}

save_db_params(){
  $JSON -e "if(this.services===undefined)this.services={};"
  $JSON -e "if(this.services.CoAuthoring===undefined)this.services.CoAuthoring={};"
  $JSON -e "if(this.services.CoAuthoring.sql===undefined)this.services.CoAuthoring.sql={};" >/dev/null 2>&1
  $JSON -e "if(this.services.CoAuthoring.sql.type===undefined)this.services.CoAuthoring.sql.type = '$DB_TYPE'"
  $JSON -e "if(this.services.CoAuthoring.sql.dbHost===undefined)this.services.CoAuthoring.sql.dbHost = '$DB_HOST'"
  $JSON -e "if(this.services.CoAuthoring.sql.dbPort===undefined)this.services.CoAuthoring.sql.dbPort = '$DB_PORT'"
  $JSON -e "if(this.services.CoAuthoring.sql.dbName===undefined)this.services.CoAuthoring.sql.dbName = '$DB_NAME'"
  $JSON -e "if(this.services.CoAuthoring.sql.dbUser===undefined)this.services.CoAuthoring.sql.dbUser = '$DB_USER'"
  $JSON -e "if(this.services.CoAuthoring.sql.dbPass===undefined)this.services.CoAuthoring.sql.dbPass = '$DB_PWD'"
}

save_rabbitmq_params(){
  $JSON -e "if(this.rabbitmq===undefined)this.rabbitmq={};"
  $JSON -e "if(this.rabbitmq.url===undefined)this.rabbitmq.url = '$RABBITMQ_PROTO://$RABBITMQ_USER:$RABBITMQ_PWD@$RABBITMQ_HOST'"
}

save_redis_params(){
  $JSON -e "if(this.services===undefined)this.services={};"
  $JSON -e "if(this.services.CoAuthoring===undefined)this.services.CoAuthoring={};"
  $JSON -e "if(this.services.CoAuthoring.redis===undefined)this.services.CoAuthoring.redis={};"
  $JSON -e "if(this.services.CoAuthoring.redis.host===undefined)this.services.CoAuthoring.redis.host = '$REDIS_HOST'"
}

save_jwt_params(){
  ${JSON} -e "if(this.services===undefined)this.services={};"
  ${JSON} -e "if(this.services.CoAuthoring===undefined)this.services.CoAuthoring={};"
  ${JSON} -e "if(this.services.CoAuthoring.token===undefined)this.services.CoAuthoring.token={};"

  if [ "${JWT_ENABLED}" = "true" ] || [ "${JWT_ENABLED}" = "false" ]; then
    ${JSON} -e "if(this.services.CoAuthoring.token.enable===undefined)this.services.CoAuthoring.token.enable={};"
    ${JSON} -e "if(this.services.CoAuthoring.token.enable.request===undefined)this.services.CoAuthoring.token.enable.request={};"
    ${JSON} -e "if(this.services.CoAuthoring.token.enable.browser===undefined)this.services.CoAuthoring.token.enable.browser = ${JWT_ENABLED}"
    ${JSON} -e "if(this.services.CoAuthoring.token.enable.request.inbox===undefined)this.services.CoAuthoring.token.enable.request.inbox = ${JWT_ENABLED}"
    ${JSON} -e "if(this.services.CoAuthoring.token.enable.request.outbox===undefined)this.services.CoAuthoring.token.enable.request.outbox = ${JWT_ENABLED}"
  fi
  
  ${JSON} -e "if(this.services.CoAuthoring.secret===undefined)this.services.CoAuthoring.secret={};"

  ${JSON} -e "if(this.services.CoAuthoring.secret.inbox===undefined)this.services.CoAuthoring.secret.inbox={};"
  ${JSON} -e "if(this.services.CoAuthoring.secret.inbox.string===undefined)this.services.CoAuthoring.secret.inbox.string = '${JWT_SECRET}'"

  ${JSON} -e "if(this.services.CoAuthoring.secret.outbox===undefined)this.services.CoAuthoring.secret.outbox={};"
  ${JSON} -e "if(this.services.CoAuthoring.secret.outbox.string===undefined)this.services.CoAuthoring.secret.outbox.string = '${JWT_SECRET}'"

  ${JSON} -e "if(this.services.CoAuthoring.secret.session===undefined)this.services.CoAuthoring.secret.session={};"
  ${JSON} -e "if(this.services.CoAuthoring.secret.session.string===undefined)this.services.CoAuthoring.secret.session.string = '${JWT_SECRET}'"
  
  ${JSON} -e "if(this.services.CoAuthoring.token.inbox===undefined)this.services.CoAuthoring.token.inbox={};"
  ${JSON} -e "if(this.services.CoAuthoring.token.inbox.header===undefined)this.services.CoAuthoring.token.inbox.header = '${JWT_HEADER}'"

  ${JSON} -e "if(this.services.CoAuthoring.token.outbox===undefined)this.services.CoAuthoring.token.outbox={};"
  ${JSON} -e "if(this.services.CoAuthoring.token.outbox.header===undefined)this.services.CoAuthoring.token.outbox.header = '${JWT_HEADER}'"

  if [ -f "${EXAMPLE_CONFIG}" ]; then
    ${JSON_EXAMPLE} -e "if(this.server===undefined)this.server={};"
    ${JSON_EXAMPLE} -e "if(this.server.token===undefined)this.server.token={};"

    if [ "${JWT_ENABLED}" = "true" ] || [ "${JWT_ENABLED}" = "false" ]; then
      ${JSON_EXAMPLE} -e "if(this.server.token.enable===undefined)this.server.token.enable = ${JWT_ENABLED}"
    fi
    ${JSON_EXAMPLE} -e "if(this.server.token.secret===undefined)this.server.token.secret = '${JWT_SECRET}'"
    ${JSON_EXAMPLE} -e "if(this.server.token.authorizationHeader===undefined)this.server.token.authorizationHeader = '${JWT_HEADER}'"
  fi
}

setup_nginx(){
   DS_CONF=$CONF_DIR/nginx/ds.conf
  
  if [ ! -e $DS_CONF ]; then
	  cp -f ${DS_CONF}.tmpl ${DS_CONF}
	  
	  # generate secure link
	  [ -z "$DS_DOCKER_INSTALLATION" ] && documentserver-update-securelink.sh -s $(tr -dc A-Za-z0-9 </dev/urandom | head -c 20) -r false
  elif ! grep -q secure_link_secret $DS_CONF; then
	  sed '/server_tokens/a \ \ set $secure_link_secret verysecretstring;' -i $DS_CONF
  fi

  db_get M4_ONLYOFFICE_VALUE/ds-port || true
  DS_PORT="$RET"
  
  # db_get M4_ONLYOFFICE_VALUE/docservice-port || true
  # DOCSERVICE_PORT="$RET"
  
  # db_get M4_ONLYOFFICE_VALUE/example-port || true
  # EXAMPLE_PORT="$RET"
  
  # setup ds port
  sed 's/\(listen .*:\)\([0-9]\{2,5\}\b\)\( default_server\)\?\(;\)/\1'${DS_PORT}'\3\4/' -i $DS_CONF

  # check if ipv6 supported otherwise remove it from nginx config
  if [ ! -f /proc/net/if_inet6 ]; then
    sed '/listen\s\+\[::[0-9]*\].\+/d' -i $DS_CONF
  fi

  # install nginx config
  if [ -d /etc/nginx/conf.d ] && [ -e /etc/nginx/conf.d/onlyoffice-documentserver.conf ]; then
    mv /etc/nginx/conf.d/onlyoffice-documentserver.conf /etc/nginx/conf.d/onlyoffice-documentserver.conf.old
  fi

  if [ -d /etc/nginx/conf.d ] && [ ! -e /etc/nginx/conf.d/ds.conf ]; then
	  ln -s $DS_CONF /etc/nginx/conf.d/ds.conf
  fi

  # sed 's/{{DOCSERVICE_PORT}}/'${DOCSERVICE_PORT}'/'  -i $OO_CONF
  # sed 's/{{EXAMPLE_PORT}}/'${EXAMPLE_PORT}'/'  -i $OO_CONF
		
  rm -f /etc/nginx/sites-enabled/default

}

save_wopi_params() {
	WOPI_PRIVATE_KEY="${CONF_DIR}/wopi_private.key"
	WOPI_PUBLIC_KEY="${CONF_DIR}/wopi_public.key"

	[ ! -f "${WOPI_PRIVATE_KEY}" ] && echo -n "Generating WOPI private key..." && openssl genpkey -algorithm RSA -outform PEM -out "${WOPI_PRIVATE_KEY}" >/dev/null 2>&1 && echo "Done"
	[ ! -f "${WOPI_PUBLIC_KEY}" ] && echo -n "Generating WOPI public key..." && openssl rsa -RSAPublicKey_out -in "${WOPI_PRIVATE_KEY}" -outform "MS PUBLICKEYBLOB" -out "${WOPI_PUBLIC_KEY}" >/dev/null 2>&1  && echo "Done"
	WOPI_MODULUS=$(openssl rsa -pubin -inform "MS PUBLICKEYBLOB" -modulus -noout -in "${WOPI_PUBLIC_KEY}" | sed 's/Modulus=//' | xxd -r -p | openssl base64 -A)
	WOPI_EXPONENT=$(openssl rsa -pubin -inform "MS PUBLICKEYBLOB" -text -noout -in "${WOPI_PUBLIC_KEY}" | grep -oP '(?<=Exponent: )\d+')

	${JSON} -e "if(this.wopi===undefined)this.wopi={};"
	${JSON} -e "this.wopi.enable = ${WOPI_ENABLED}"
	${JSON} -e "this.wopi.privateKey = '$(awk '{printf "%s\\n", $0}' ${WOPI_PRIVATE_KEY})'"
	${JSON} -e "this.wopi.privateKeyOld = '$(awk '{printf "%s\\n", $0}' ${WOPI_PRIVATE_KEY})'"
	${JSON} -e "this.wopi.publicKey = '$(openssl base64 -in ${WOPI_PUBLIC_KEY} -A)'"
	${JSON} -e "this.wopi.publicKeyOld = '$(openssl base64 -in ${WOPI_PUBLIC_KEY} -A)'"
	${JSON} -e "this.wopi.modulus = '${WOPI_MODULUS}'"
	${JSON} -e "this.wopi.modulusOld = '${WOPI_MODULUS}'"
	${JSON} -e "this.wopi.exponent = ${WOPI_EXPONENT}"
	${JSON} -e "this.wopi.exponentOld = ${WOPI_EXPONENT}"
}

case "$1" in
	configure)
		adduser --quiet --home "$DIR" --system --group ds

		# add nginx user to M4_ONLYOFFICE_VALUE group to allow access nginx to M4_ONLYOFFICE_VALUE log dir
		adduser --quiet www-data ds

		read_saved_params
		create_local_configs
		install_db
		save_db_params
		save_rabbitmq_params
ifelse(eval(ifelse(M4_PRODUCT_NAME,documentserver-ee,1,0)||ifelse(M4_PRODUCT_NAME,documentserver-ie,1,0)||ifelse(M4_PRODUCT_NAME,documentserver-de,1,0)),1,
`		save_redis_params
',)dnl
		save_jwt_params
		[ -z "$DS_DOCKER_INSTALLATION" ] && save_wopi_params

		# configure ngninx for M4_ONLYOFFICE_VALUE
		setup_nginx

		# modify permissions for M4_ONLYOFFICE_VALUE files and folders
		mkdir -p "$LOG_DIR/docservice"
		mkdir -p "$LOG_DIR-example"
		mkdir -p "$LOG_DIR/converter"
		mkdir -p "$LOG_DIR/metrics"

		mkdir -p "$APP_DIR/App_Data"
		mkdir -p "$APP_DIR/App_Data/cache/files"
		mkdir -p "$APP_DIR/App_Data/docbuilder"
		mkdir -p "$APP_DIR-example/files"

		mkdir -p "$DIR/../Data" #! 
		mkdir -p "$DIR/fonts"
		
		# grand owner rights for home dir for ds user
		chown ds:ds -R "$DIR/../Data" "$DIR"*
		# set up read-only access to prevent modification ds's home directory
		chmod a-w -R "$DIR"*

    #setup logrotate config rights
    chmod 644 ${CONF_DIR}/logrotate/*
    chown root:root ${CONF_DIR}/logrotate/*

		# generate allfonts.js, thumbnail and cache_tag
		if [ -z "$DS_DOCKER_INSTALLATION" ]; then
			documentserver-generate-allfonts.sh true
			documentserver-flush-cache.sh -r false
		fi

		# install/update plugins
		if [ "$DS_PLUGIN_INSTALLATION" = "true" ]; then
			echo -n Installing plugins, please wait...
			documentserver-pluginsmanager.sh -r false --update=\"$DIR/sdkjs-plugins/plugin-list-default.json\" >/dev/null
			echo Done
		fi

		#Deleting the cache left before updating the document server (Bug #60628)
		CACHE_PATH="${APP_DIR}/App_Data/cache/files/data"
		[ -d "${CACHE_PATH}" ] && rm -rf "${CACHE_PATH}"/*

		chown ds:ds -R "$LOG_DIR"
		chown ds:ds -R "$LOG_DIR-example"
		chown ds:ds -R "$APP_DIR"
		chown ds:ds -R "$APP_DIR-example"

		if [ -d /etc/M4_DS_PREFIX/supervisor ]; then
			rm -rf /etc/M4_DS_PREFIX*/supervisor
			supervisorctl update 2>/dev/null || true
		fi

		# call db_stop to prevent installation hang
		db_stop

		# restart dependent services
		if [ -z "$DS_DOCKER_INSTALLATION" ]; then
			for SVC in M4_PACKAGE_SERVICES; do
				if [ -e /usr/lib/systemd/system/$SVC.service ]; then
					systemctl enable $SVC >/dev/null 2>&1
					systemctl restart $SVC >/dev/null 2>&1
				fi
			done
			systemctl is-active --quiet ds-example && systemctl restart ds-example
			service nginx restart >/dev/null 2>&1
		fi
		echo "Congratulations, the M4_COMPANY_NAME M4_PRODUCT_NAME has been installed successfully!"
		echo "$JWT_MESSAGE"
	;;

	abort-upgrade|abort-remove|abort-deconfigure)
	;;
	
	triggered)
		documentserver-generate-allfonts.sh true
		documentserver-flush-cache.sh
	;;
	
	*)
		echo "postinst called with unknown argument \`$1'" >&2
		exit 1
	;;
esac

# dh_installdeb will replace this with shell code automatically
# generated by other debhelper scripts.

#DEBHELPER#

exit 0
