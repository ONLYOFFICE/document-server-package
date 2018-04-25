#!/bin/bash

DIR="/var/www/onlyoffice"
LOCAL_CONFIG="/etc/onlyoffice/documentserver/local.json"
JSON=json -I -q -f $LOCAL_CONFIG

PSQL=""
CREATEDB=""

DS_PORT=${DS_PORT:-80}
# DOCSERVICE_PORT=${DOCSERVICE_PORT:-8000}
# SPELLCHECKER_PORT=${SPELLCHECKER_PORT:-8080}
# EXAMPLE_PORT=${EXAMPLE_PORT:-3000}

[ $(id -u) -ne 0 ] && { echo "Root privileges required"; exit 1; }

npm list -g json >/dev/null 2>&1 || npm install -g json >/dev/null 2>&1

create_local_configs(){
	for i in $LOCAL_CONFIG $EXAMPLE_CONFIG; do
		if [ ! -f ${i} ]; then
			echo {} > ${i}
		fi
  	done
}

restart_services() {
	[ -a /etc/nginx/sites-available.d/default.conf ] && mv /etc/nginx/sites-available.d/default.conf /etc/nginx/sites-available.d/default.conf.old

	echo -n "Restarting services... "
	for SVC in supervisord nginx
	do
		/sbin/service $SVC restart
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
  $JSON -e "this.rabbitmq.url = 'amqp://$RABBITMQ_USER:$RABBITMQ_PWD@$RABBITMQ_HOST'"
}

save_redis_params(){
  $JSON -e "if(this.services===undefined)this.services={};"
  $JSON -e "if(this.services.CoAuthoring===undefined)this.services.CoAuthoring={};"
  $JSON -e "if(this.services.CoAuthoring.redis===undefined)this.services.CoAuthoring.redis={};"
  $JSON -e "this.services.CoAuthoring.redis.host = '$REDIS_HOST'"
}

parse_rabbitmq_url(){
  local amqp=${RABBITMQ_URL}

  # extract the protocol
  local proto="$(echo $amqp | grep :// | sed -e's,^\(.*://\).*,\1,g')"
  # remove the protocol
  local url="$(echo ${amqp/$proto/})"

  # extract the user and password (if any)
  local userpass="`echo $url | grep @ | cut -d@ -f1`"
  local pass=`echo $userpass | grep : | cut -d: -f2`

  local user
  if [ -n "$pass" ]; then
    user=`echo $userpass | grep : | cut -d: -f1`
  else
    user=$userpass
  fi

  # extract the host
  local hostport="$(echo ${url/$userpass@/} | cut -d/ -f1)"
  # by request - try to extract the port
  local port="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"

  local host
  if [ -n "$port" ]; then
    host=`echo $hostport | grep : | cut -d: -f1`
  else
    host=$hostport
    port="5672"
  fi

  # extract the path (if any)
  local path="$(echo $url | grep / | cut -d/ -f2-)"

  RABBITMQ_HOST=$hostport$path
  RABBITMQ_USER=$user
  RABBITMQ_PWD=$pass
}

input_db_params(){
	echo "Configuring PostgreSQL access... "

	read -e -p "Host [${DB_HOST}]: " USER_INPUT
	DB_HOST=${USER_INPUT:-${DB_HOST}}

	read -e -p "Database name [${DB_NAME}]: " USER_INPUT
	DB_NAME=${USER_INPUT:-${DB_NAME}}

	read -e -p "User [${DB_USER}]: " USER_INPUT
	DB_USER=${USER_INPUT:-${DB_USER}}

	read -e -p "Password []: " -s USER_INPUT
	DB_PWD=${USER_INPUT:-${DB_PWD}}

	echo
}

input_redis_params(){
	echo "Configuring redis access... "

	read -e -p "Host [${REDIS_HOST}]: " USER_INPUT
	REDIS_HOST=${USER_INPUT:-${REDIS_HOST}}

	echo
}

input_rabbitmq_params(){
	echo "Configuring RabbitMQ access... "

	read -e -p "Host [${RABBITMQ_HOST}]: " USER_INPUT
	RABBITMQ_HOST=${USER_INPUT:-${RABBITMQ_HOST}}

	read -e -p "User [${RABBITMQ_USER}]: " USER_INPUT
	RABBITMQ_USER=${USER_INPUT:-${RABBITMQ_USER}}

	read -e -p "Password []: " -s USER_INPUT
	RABBITMQ_PWD=${USER_INPUT:-${RABBITMQ_PWD}}

	echo
}

execute_db_scripts(){
	echo -n "Installing PostgreSQL database... "

        if ! $PSQL -lt | cut -d\| -f 1 | grep -qw $DB_NAME; then
                $CREATEDB $DB_NAME >/dev/null 2>&1
        fi

        if [ ! "$CLUSTER_MODE" = true ]; then
                $PSQL -d "$DB_NAME" -f "$DIR/documentserver/server/schema/postgresql/removetbl.sql" >/dev/null 2>&1
        fi

	$PSQL -d "$DB_NAME" -f "$DIR/documentserver/server/schema/postgresql/createdb.sql" >/dev/null 2>&1

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

	TEST_QUEUE=dc.test
	RABBITMQ_URL=amqp://$RABBITMQ_USER:$RABBITMQ_PWD@$RABBITMQ_HOST

	amqp-declare-queue -u "$RABBITMQ_URL" -q "$TEST_QUEUE" >/dev/null 2>&1 || { echo "FAILURE"; exit 1; }
	amqp-delete-queue -u "$RABBITMQ_URL" -q "$TEST_QUEUE" >/dev/null 2>&1 || { echo "FAILURE"; exit 1; }

	echo "OK"
}

setup_nginx(){
  NGINX_CONF_DIR=/etc/onlyoffice/documentserver/nginx
  DS_CONF=$NGINX_CONF_DIR/onlyoffice-documentserver.conf.template
  DS_SSL_CONF=$NGINX_CONF_DIR/onlyoffice-documentserver-ssl.conf.template

  # OO_CONF=$NGINX_CONF_DIR/includes/onlyoffice-http.conf
  sed 's/\(listen .*:\)\([0-9]\{2,5\}\b\)\( default_server\)\?\(;\)/\1'${DS_PORT}'\3\4/' -i $DS_CONF

  # sed 's/{{DOCSERVICE_PORT}}/'${DOCSERVICE_PORT}'/' -i $OO_CONF
  # sed 's/{{SPELLCHECKER_PORT}}/'${SPELLCHECKER_PORT}'/' -i $OO_CONF
  # sed 's/{{EXAMPLE_PORT}}/'${EXAMPLE_PORT}'/' -i $OO_CONF

  # check whethere enabled
  shopt -s nocasematch
  PORTS=()
  case $(/usr/sbin/getenforce) in
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
    /usr/sbin/semanage port -a -t http_port_t -p tcp $PORT >/dev/null 2>&1 || \
      /usr/sbin/semanage port -m -t http_port_t -p tcp $PORT >/dev/null 2>&1 || \
      true
  done
}

create_local_configs

input_db_params
establish_db_conn || exit $?
execute_db_scripts || exit $?

input_redis_params
# establish_redis_conn || exit $?

input_rabbitmq_params
# establish_rabbitmq_conn || exit $?

save_db_params
save_rabbitmq_params
save_redis_params

setup_nginx

restart_services
