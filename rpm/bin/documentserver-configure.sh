#!/bin/sh

DIR="/var/www/onlyoffice"
DEFAULT_CONFIG="/etc/onlyoffice/documentserver/default.json"
SAVED_DEFAULT_CONFIG="$DEFAULT_CONFIG.rpmsave"

PSQL=""
CREATEDB=""

[ $(id -u) -ne 0 ] && { echo "Root privileges required"; exit 1; }

npm list -g json >/dev/null 2>&1 || npm install -g json >/dev/null 2>&1

restart_services() {
	[ -a /etc/nginx/conf.d/default.conf ] && mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.old

	echo -n "Restarting services... "
	for SVC in supervisord nginx
	do
		systemctl stop $SVC 
		systemctl start $SVC
	done
	echo "OK"
}

save_db_params(){
	json -I -f $DEFAULT_CONFIG -e "this.services.CoAuthoring.sql.dbHost = '$DB_HOST'" >/dev/null 2>&1
	json -I -f $DEFAULT_CONFIG -e "this.services.CoAuthoring.sql.dbName= '$DB_NAME'" >/dev/null 2>&1
	json -I -f $DEFAULT_CONFIG -e "this.services.CoAuthoring.sql.dbUser = '$DB_USER'" >/dev/null 2>&1
	json -I -f $DEFAULT_CONFIG -e "this.services.CoAuthoring.sql.dbPass = '$DB_PWD'" >/dev/null 2>&1
}

delete_saved_params()
{
	rm -f $SAVED_DEFAULT_CONFIG
}

save_rabbitmq_params(){
	json -I -f $DEFAULT_CONFIG -e "this.rabbitmq.url = 'amqp://$RABBITMQ_HOST'" >/dev/null 2>&1
	json -I -f $DEFAULT_CONFIG -e "this.rabbitmq.login = '$RABBITMQ_USER'" >/dev/null 2>&1
	json -I -f $DEFAULT_CONFIG -e "this.rabbitmq.password = '$RABBITMQ_PWD'" >/dev/null 2>&1
}

save_redis_params(){
	json -I -f $DEFAULT_CONFIG -e "this.services.CoAuthoring.redis.host = '$REDIS_HOST'" >/dev/null 2>&1
}

read_saved_params(){
	CONFIG_TO_READ=$SAVED_DEFAULT_CONFIG

	if [ ! -e $CONFIG_TO_READ ]; then
		CONFIG_TO_READ=$DEFAULT_CONFIG
	fi

	if [ -e $CONFIG_TO_READ ]; then
		DB_HOST=$(json -f "$CONFIG_TO_READ" services.CoAuthoring.sql.dbHost)
		DB_NAME=$(json -f "$CONFIG_TO_READ" services.CoAuthoring.sql.dbName)
		DB_USER=$(json -f "$CONFIG_TO_READ" services.CoAuthoring.sql.dbUser)
		DB_PWD=$(json -f "$CONFIG_TO_READ" services.CoAuthoring.sql.dbPass)

		REDIS_HOST=$(json -f "$CONFIG_TO_READ" services.CoAuthoring.redis.host)

		RABBITMQ_HOST=$(json -f "$CONFIG_TO_READ" rabbitmq.url | cut -c8-)
		RABBITMQ_USER=$(json -f "$CONFIG_TO_READ" rabbitmq.login)
		RABBITMQ_PWD=$(json -f "$CONFIG_TO_READ" rabbitmq.password) 
	fi
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
	read -e -p "Host: " -i "$RABBITMQ_HOST" RABBITMQ_HOST
	read -e -p "User: " -i "$RABBITMQ_USER" RABBITMQ_USER 
	read -e -p "Password: " -s RABBITMQ_PWD
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
  NGINX_CONF_DIR=/etc/nginx
  DS_CONF=$NGINX_CONF_DIR/conf.d/onlyoffice-documentserver.conf
  OO_CONF=$NGINX_CONF_DIR/includes/onlyoffice-http.conf
  sed 's/{{DS_PORT}}/'80'/'  -i $DS_CONF
  sed 's/{{DOCSERVICE_PORT}}/'8000'/'  -i $OO_CONF
  sed 's/{{SPELLCHECKER_PORT}}/'8080'/'  -i $OO_CONF
  sed 's/{{EXAMPLE_PORT}}/'3000'/'  -i $OO_CONF
}

read_saved_params

input_db_params
establish_db_conn || exit $?
execute_db_scripts || exit $?

input_redis_params
establish_redis_conn || exit $?

input_rabbitmq_params
establish_rabbitmq_conn || exit $?

save_db_params
save_rabbitmq_params
save_redis_params

delete_saved_params

setup_nginx

restart_services
