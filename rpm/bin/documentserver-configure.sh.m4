#!/bin/bash

DIR="/var/www/M4_DS_PREFIX"
LOCAL_CONFIG="/etc/M4_DS_PREFIX/local.json"
EXAMPLE_CONFIG="/etc/M4_DS_PREFIX-example/local.json"
JSON_BIN="$DIR/npm/json"
JSON="$JSON_BIN -I -q -f $LOCAL_CONFIG"
JSON_EXAMPLE="$JSON_BIN -I -q -f $EXAMPLE_CONFIG"

AMQP_SERVER_PROTO=${AMQP_SERVER_PROTO:-amqp}
AMQP_SERVER_TYPE=${AMQP_SERVER_TYPE:-rabbitmq}

MYSQL=""
PSQL=""
CREATEDB=""
DB_TYPE=${DB_TYPE:-postgres}
DB_PORT=""
DS_PORT=${DS_PORT:-80}
# DOCSERVICE_PORT=${DOCSERVICE_PORT:-8000}
# EXAMPLE_PORT=${EXAMPLE_PORT:-3000}

JWT_ENABLED=${JWT_ENABLED:-false}
JWT_SECRET=${JWT_SECRET:-$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)}
JWT_HEADER=${JWT_HEADER:-Authorization}

if [ ! -f $LOCAL_CONFIG ] && [ "${JWT_ENABLED}" == "true" ]; then
	JWT_MESSAGE="JWT is enabled by default. A random secret is generated automatically. Run the command '# documentserver-jwt-status.sh' to get information about JWT."
fi

[ $(id -u) -ne 0 ] && { echo "Root privileges required"; exit 1; }

create_local_configs(){
	for i in $LOCAL_CONFIG $EXAMPLE_CONFIG; do
		if [ ! -f ${i} ]; then
			install -m 640 -D /dev/null ${i}
			echo {} > ${i}
		fi
  	done
}

tune_local_configs(){
	for i in $LOCAL_CONFIG $EXAMPLE_CONFIG; do
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
	for SVC in supervisord nginx
	do
		systemctl restart $SVC 
	done
	echo "OK"
}

save_db_params(){
	$JSON -e "if(this.services===undefined)this.services={};"
	$JSON -e "if(this.services.CoAuthoring===undefined)this.services.CoAuthoring={};"
	$JSON -e "if(this.services.CoAuthoring.sql===undefined)this.services.CoAuthoring.sql={};"
	$JSON -e "this.services.CoAuthoring.sql.dbHost = '$DB_HOST'"
	$JSON -e "this.services.CoAuthoring.sql.dbName= '$DB_NAME'"
	$JSON -e "this.services.CoAuthoring.sql.dbUser = '$DB_USER'"
	$JSON -e "this.services.CoAuthoring.sql.dbPass = '$DB_PWD'"
	$JSON -e "this.services.CoAuthoring.sql.type = '$DB_TYPE'"
	$JSON -e "this.services.CoAuthoring.sql.dbPort = '$DB_PORT'"
}

save_rabbitmq_params(){
	$JSON -e "if(this.queue===undefined)this.queue={};"
	$JSON -e "this.queue.type = 'rabbitmq'"
	$JSON -e "if(this.rabbitmq===undefined)this.rabbitmq={};"
	$JSON -e "this.rabbitmq.url = '${AMQP_SERVER_URL}'"
}

save_activemq_params(){
	$JSON -e "if(this.queue===undefined)this.queue={};"
	$JSON -e "this.queue.type = 'activemq'"
	$JSON -e "if(this.activemq===undefined)this.activemq={};"
	$JSON -e "if(this.activemq.connectOptions===undefined)this.activemq.connectOptions={};"

	$JSON -e "this.activemq.connectOptions.host = '${AMQP_SERVER_HOST}'"
	if [ ! "${AMQP_SERVER_PORT}" == "" ]; then
		$JSON -e "this.activemq.connectOptions.port = '${AMQP_SERVER_PORT}'"
	else
		$JSON -e "delete this.activemq.connectOptions.port"
	fi

	if [ ! "${AMQP_SERVER_USER}" == "" ]; then
		$JSON -e "this.activemq.connectOptions.username = '${AMQP_SERVER_USER}'"
	else
		$JSON -e "delete this.activemq.connectOptions.username"
	fi

	if [ ! "${AMQP_SERVER_PWD}" == "" ]; then
		$JSON -e "this.activemq.connectOptions.password = '${AMQP_SERVER_PWD}'"
	else
		$JSON -e "delete this.activemq.connectOptions.password"
	fi

	case "${AMQP_SERVER_PROTO}" in
		amqp+ssl|amqps)
			$JSON -e "this.activemq.connectOptions.transport = 'tls'"
		;;
		*)
			$JSON -e "delete this.activemq.connectOptions.transport"
		;;
	esac 
}

save_redis_params(){
	$JSON -e "if(this.services===undefined)this.services={};"
	$JSON -e "if(this.services.CoAuthoring===undefined)this.services.CoAuthoring={};"
	$JSON -e "if(this.services.CoAuthoring.redis===undefined)this.services.CoAuthoring.redis={};"
	$JSON -e "this.services.CoAuthoring.redis.host = '$REDIS_HOST'"
}

save_jwt_params(){
	${JSON} -e "if(this.services===undefined)this.services={};"
	${JSON} -e "if(this.services.CoAuthoring===undefined)this.services.CoAuthoring={};"
	${JSON} -e "if(this.services.CoAuthoring.token===undefined)this.services.CoAuthoring.token={};"

  if [ "${JWT_ENABLED}" == "true" -o "${JWT_ENABLED}" == "false" ]; then
		${JSON} -e "if(this.services.CoAuthoring.token.enable===undefined)this.services.CoAuthoring.token.enable={};"
		${JSON} -e "if(this.services.CoAuthoring.token.enable.request===undefined)this.services.CoAuthoring.token.enable.request={};"
		${JSON} -e "this.services.CoAuthoring.token.enable.browser = ${JWT_ENABLED}"
		${JSON} -e "this.services.CoAuthoring.token.enable.request.inbox = ${JWT_ENABLED}"
		${JSON} -e "this.services.CoAuthoring.token.enable.request.outbox = ${JWT_ENABLED}"
  fi
  
	${JSON} -e "if(this.services.CoAuthoring.secret===undefined)this.services.CoAuthoring.secret={};"

	${JSON} -e "if(this.services.CoAuthoring.secret.inbox===undefined)this.services.CoAuthoring.secret.inbox={};"
	${JSON} -e "this.services.CoAuthoring.secret.inbox.string = '${JWT_SECRET}'"

	${JSON} -e "if(this.services.CoAuthoring.secret.outbox===undefined)this.services.CoAuthoring.secret.outbox={};"
	${JSON} -e "this.services.CoAuthoring.secret.outbox.string = '${JWT_SECRET}'"

	${JSON} -e "if(this.services.CoAuthoring.secret.session===undefined)this.services.CoAuthoring.secret.session={};"
	${JSON} -e "this.services.CoAuthoring.secret.session.string = '${JWT_SECRET}'"

	${JSON} -e "if(this.services.CoAuthoring.token.inbox===undefined)this.services.CoAuthoring.token.inbox={};"
	${JSON} -e "this.services.CoAuthoring.token.inbox.header = '${JWT_HEADER}'"

	${JSON} -e "if(this.services.CoAuthoring.token.outbox===undefined)this.services.CoAuthoring.token.outbox={};"
	${JSON} -e "this.services.CoAuthoring.token.outbox.header = '${JWT_HEADER}'"

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

parse_amqp_url(){
  local amqp=${AMQP_SERVER_URL}

  # extract the protocol
  local proto="$(echo $amqp | grep :// | sed -e's,^\(.*://\).*,\1,g')"
  # remove the protocol
  local url="$(echo ${amqp/$proto/})"

  # extract the user and password (if any)
  local userpass="$(echo $url | grep @ | cut -d@ -f1)"
  local pass=$(echo $userpass | grep : | cut -d: -f2)

  local user
  if [ -n "$pass" ]; then
    user=$(echo $userpass | grep : | cut -d: -f1)
  else
    user=$userpass
  fi

  # extract the host
  local hostport="$(echo ${url/$userpass@/} | cut -d/ -f1)"
  # by request - try to extract the port
  local port="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"

  local host
  if [ -n "$port" ]; then
    host=$(echo $hostport | grep : | cut -d: -f1)
  else
    host=$hostport
    port="5672"
  fi

  # extract the path (if any)
  local path="$(echo $url | grep / | cut -d/ -f2-)"

  AMQP_SERVER_PROTO=${proto%://}
  AMQP_SERVER_HOST=$host
  AMQP_SERVER_PORT=$port
  AMQP_SERVER_HOST_PORT_PATH=$hostport$path
  AMQP_SERVER_USER=$user
  AMQP_SERVER_PWD=$pass
}

input_db_params(){
	echo "Configuring database access... "
	read -e -p "Host: " -i "$DB_HOST" DB_HOST
	read -e -p "Database name: " -i "$DB_NAME" DB_NAME
	read -e -p "User: " -i "$DB_USER" DB_USER 
	read -e -p "Password: " -s DB_PWD
	echo
}

input_redis_params(){
	echo "Configuring redis access... "
	read -e -p "Host: " -i "$REDIS_HOST" REDIS_HOST
	echo
}

input_amqp_params(){
	echo "Configuring AMQP access... "
	read -e -p "Host: " -i "$AMQP_SERVER_HOST_PORT_PATH" AMQP_SERVER_HOST_PORT_PATH
	read -e -p "User: " -i "$AMQP_SERVER_USER" AMQP_SERVER_USER 
	read -e -p "Password: " -s AMQP_SERVER_PWD
	AMQP_SERVER_URL=$AMQP_SERVER_PROTO://$AMQP_SERVER_USER:$AMQP_SERVER_PWD@$AMQP_SERVER_HOST_PORT_PATH
	echo
}

execute_postgres_scripts(){
	echo -n "Installing PostgreSQL database... "

        if [ ! "$CLUSTER_MODE" = true ]; then
                $PSQL -f "$DIR/server/schema/postgresql/removetbl.sql" >/dev/null 2>&1
        fi

	$PSQL -f "$DIR/server/schema/postgresql/createdb.sql" >/dev/null 2>&1
	echo "OK"
}

establish_postgres_conn() {
	echo -n "Trying to establish PostgreSQL connection... "

	command -v psql >/dev/null 2>&1 || { echo "PostgreSQL client not found"; exit 1; }

        if [ -n "$DB_PWD" ]; then
                export PGPASSWORD=$DB_PWD
        fi

	PSQL="psql -q -h$DB_HOST -d$DB_NAME -U$DB_USER -w"
	$PSQL -c ";" >/dev/null 2>&1 || { echo "FAILURE"; exit 1; }

	echo "OK"
}

execute_mysql_sqript(){
	echo -n "Installing MYSQL database... "
	$MYSQL -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8 COLLATE 'utf8_general_ci';" 
	$MYSQL "$DB_NAME" < "$DIR/server/schema/mysql/createdb.sql" 
	echo "OK"
}

establish_mysql_conn(){
	echo -n "Trying to database MySQL connection... "
	command -v mysql >/dev/null 2>&1 || { echo "MySQL client not found"; exit 1; }
	MYSQL="mysql -h$DB_HOST -u$DB_USER"
	if [ -n "$DB_PWD" ]; then
		MYSQL="$MYSQL -p$DB_PWD"
	fi 

	$MYSQL -e ";" >/dev/null 2>&1 || { echo "FAILURE"; exit 1; }

	echo "OK"
}

execute_db_script(){
	case $DB_TYPE in
		postgres)
			DB_PORT=5432 
			establish_postgres_conn || exit $?
			execute_postgres_scripts || exit $?
			;;	
		mysql) 
			DB_PORT=3306  
			establish_mysql_conn || exit $?
			execute_mysql_sqript || exit $?
			;;   
		*)
			echo "Incorrect DB_TYPE value! Possible value of DB_TYPE is 'postgres' or 'mysql'."
			exit 1	  
	esac
}

establish_redis_conn() {
	echo -n "Trying to establish redis connection... "

	exec {FD}<> /dev/tcp/$REDIS_HOST/6379 && exec {FD}>&-

	if [ "$?" != 0 ]; then
		echo "FAILURE";
		exit 1;
	fi

	echo "OK"
}

establish_amqp_conn() {
	echo -n "Trying to establish AMQP connection... "
  
	exec {FD}<> /dev/tcp/$AMQP_SERVER_HOST/$AMQP_SERVER_PORT && exec {FD}>&-

	if [ "$?" != 0 ]; then
		echo "FAILURE";
		exit 1;
	fi

	echo "OK"
}

save_amqp_params(){
	case $AMQP_SERVER_TYPE in
		activemq)
			save_activemq_params
			;;
		rabbitmq)
			save_rabbitmq_params
			;;
		*)
			echo "Incorrect AMQP_SERVER_TYPE value! Possible value of AMQP_SERVER_TYPE is 'activemq' or 'rabbitmq"
			exit 1
			;;
	esac
}

setup_nginx(){
  NGINX_CONF_DIR=/etc/M4_DS_PREFIX/nginx
  DS_CONF_TMPL=$NGINX_CONF_DIR/ds.conf.tmpl
  DS_CONF=$NGINX_CONF_DIR/ds.conf

  cp -f ${DS_CONF_TMPL} ${DS_CONF}
  sed 's/\(listen .*:\)\([0-9]\{2,5\}\b\)\( default_server\)\?\(;\)/\1'${DS_PORT}'\3\4/' -i $DS_CONF

  # check if ipv6 supported otherwise remove it from nginx config
  if [ ! -f /proc/net/if_inet6 ]; then
    sed '/listen\s\+\[::[0-9]*\].\+/d' -i $DS_CONF
  fi

  # sed 's/{{DOCSERVICE_PORT}}/'${DOCSERVICE_PORT}'/' -i $OO_CONF
  # sed 's/{{EXAMPLE_PORT}}/'${EXAMPLE_PORT}'/' -i $OO_CONF

  # check whethere enabled
  shopt -s nocasematch
  PORTS=()
  case $(getenforce) in
    enforcing|permissive)
      PORTS+=('8000')
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

input_db_params
execute_db_script

ifelse(eval(ifelse(M4_PRODUCT_NAME,documentserver-ee,1,0)||ifelse(M4_PRODUCT_NAME,documentserver-ie,1,0)||ifelse(M4_PRODUCT_NAME,documentserver-de,1,0)),1,
input_redis_params
establish_redis_conn || exit $?

,)dnl
input_amqp_params
parse_amqp_url
establish_amqp_conn || exit $?

save_db_params
save_amqp_params
ifelse(eval(ifelse(M4_PRODUCT_NAME,documentserver-ee,1,0)||ifelse(M4_PRODUCT_NAME,documentserver-ie,1,0)||ifelse(M4_PRODUCT_NAME,documentserver-de,1,0)),1,
save_redis_params
,)dnl
save_jwt_params

tune_local_configs

setup_nginx

# generate secure link
documentserver-update-securelink.sh

restart_services

echo $JWT_MESSAGE
