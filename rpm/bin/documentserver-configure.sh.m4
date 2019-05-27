#!/bin/bash

DIR="/var/www/M4_DS_PREFIX"
LOCAL_CONFIG="/etc/M4_DS_PREFIX/local.json"
EXAMPLE_CONFIG="/etc/M4_DS_PREFIX-example/local.json"
JSON_BIN="$DIR/npm/node_modules/.bin/json"
JSON="$JSON_BIN -I -q -f $LOCAL_CONFIG"
JSON_EXAMPLE="$JSON_BIN -I -q -f $EXAMPLE_CONFIG"

PSQL=""
CREATEDB=""

DS_PORT=${DS_PORT:-80}
# DOCSERVICE_PORT=${DOCSERVICE_PORT:-8000}
# SPELLCHECKER_PORT=${SPELLCHECKER_PORT:-8080}
# EXAMPLE_PORT=${EXAMPLE_PORT:-3000}

JWT_ENABLED=${JWT_ENABLED:-false}
JWT_SECRET=${JWT_SECRET:-secret}
JWT_HEADER=${JWT_HEADER:-Authorization}

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
	[ -a /etc/nginx/conf.d/default.conf ] && mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.old

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
}

save_rabbitmq_params(){
	$JSON -e "if(this.rabbitmq===undefined)this.rabbitmq={};"
	$JSON -e "this.rabbitmq.url = '$RABBITMQ_URL'"
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

parse_rabbitmq_url(){
  local amqp=${RABBITMQ_URL}

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

  RABBITMQ_HOST=$host
  RABBITMQ_PORT=$port
  RABBITMQ_HOST_PORT_PATH=$hostport$path
  RABBITMQ_USER=$user
  RABBITMQ_PWD=$pass
}

input_db_params(){
	echo "Configuring PostgreSQL access... "
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

input_rabbitmq_params(){
	echo "Configuring RabbitMQ access... "
	read -e -p "Host: " -i "$RABBITMQ_HOST_PORT_PATH" RABBITMQ_HOST_PORT_PATH
	read -e -p "User: " -i "$RABBITMQ_USER" RABBITMQ_USER 
	read -e -p "Password: " -s RABBITMQ_PWD
	RABBITMQ_URL=amqp://$RABBITMQ_USER:$RABBITMQ_PWD@$RABBITMQ_HOST_PORT_PATH
	echo
}

execute_db_scripts(){
	echo -n "Installing PostgreSQL database... "

        if ! $PSQL -lt | cut -d\| -f 1 | grep -qw $DB_NAME; then
                $CREATEDB $DB_NAME >/dev/null 2>&1
        fi

        if [ ! "$CLUSTER_MODE" = true ]; then
                $PSQL -d "$DB_NAME" -f "$DIR/server/schema/postgresql/removetbl.sql" >/dev/null 2>&1
        fi
	
	$PSQL -d "$DB_NAME" -f "$DIR/server/schema/postgresql/createdb.sql" >/dev/null 2>&1

	echo "OK"
}

establish_db_conn() {
	echo -n "Trying to establish PostgreSQL connection... "

	command -v psql >/dev/null 2>&1 || { echo "PostgreSQL client not found"; exit 1; }

        CONNECTION_PARAMS="-h$DB_HOST -U$DB_USER -w"
        if [ -n "$DB_PWD" ]; then
                export PGPASSWORD=$DB_PWD
        fi

        PSQL="psql -q $CONNECTION_PARAMS"
        CREATEDB="createdb $CONNECTION_PARAMS"

	$PSQL -c ";" >/dev/null 2>&1 || { echo "FAILURE"; exit 1; }

	echo "OK"
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

establish_rabbitmq_conn() {
	echo -n "Trying to establish RabbitMQ connection... "
  
  exec {FD}<> /dev/tcp/$RABBITMQ_HOST/$RABBITMQ_PORT && exec {FD}>&-

	if [ "$?" != 0 ]; then
		echo "FAILURE";
		exit 1;
	fi

	echo "OK"
}

establish_rabbitmq_conn_by_tools() {
	echo -n "Trying to establish RabbitMQ connection... "

	TEST_QUEUE=dc.test
	RABBITMQ_URL=amqp://$RABBITMQ_USER:$RABBITMQ_PWD@$RABBITMQ_HOST_PORT_PATH

	amqp-declare-queue -u "$RABBITMQ_URL" -q "$TEST_QUEUE" >/dev/null 2>&1 || { echo "FAILURE"; exit 1; }
	amqp-delete-queue -u "$RABBITMQ_URL" -q "$TEST_QUEUE" >/dev/null 2>&1 || { echo "FAILURE"; exit 1; }

	echo "OK"
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
  # sed 's/{{SPELLCHECKER_PORT}}/'${SPELLCHECKER_PORT}'/' -i $OO_CONF
  # sed 's/{{EXAMPLE_PORT}}/'${EXAMPLE_PORT}'/' -i $OO_CONF

  # check whethere enabled
  shopt -s nocasematch
  PORTS=()
  case $(getenforce) in
    enforcing|permissive)
      PORTS+=('8000')
      PORTS+=('8080')
      PORTS+=('3000')
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
establish_db_conn || exit $?
execute_db_scripts || exit $?

input_redis_params
establish_redis_conn || exit $?

input_rabbitmq_params
parse_rabbitmq_url
establish_rabbitmq_conn || exit $?

save_db_params
save_rabbitmq_params
save_redis_params
save_jwt_params

tune_local_configs

setup_nginx

restart_services
