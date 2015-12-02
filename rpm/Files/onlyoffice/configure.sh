#!/bin/sh

DIR="/var/www/onlyoffice"
DEFAULT_CONFIG="$DIR/documentserver/NodeJsProjects/Common/config/default.json"
CONF=$DIR/WebStudio/web.connections.config
DB_HOST="localhost"
DB_NAME="onlyoffice"
DB_USER="root"
DB_PWD="onlyoffice"
MYSQL=""

[ $(id -u) -ne 0 ] && { echo "Root privileges required"; exit 1; }

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
	sed 's/"dbHost".*"/"dbHost": "'$DB_HOST'"/' -i $DEFAULT_CONFIG
	sed 's/"dbName".*"/"dbName": "'$DB_NAME'"/' -i $DEFAULT_CONFIG
	sed 's/"dbUser".*"/"dbUser": "'$DB_USER'"/' -i $DEFAULT_CONFIG
	sed 's/"dbPass".*"/"dbPass": "'$DB_PWD'"/' -i $DEFAULT_CONFIG
}

read_db_params(){
	echo "Configuring MySQL access... "
	read -e -p "Host: " -i "$DB_HOST" DB_HOST
	read -e -p "Database name: " -i "$DB_NAME" DB_NAME
	read -e -p "User: " -i "$DB_USER" DB_USER 
	read -e -p "Password: " -s DB_PWD
  echo
}

execute_db_scripts(){
	echo -n "Installing MySQL database... "
  
	if [ "$OLD_VERSION" = "" ]; then
		$MYSQL -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8 COLLATE 'utf8_general_ci';"
	fi
	
	$MYSQL "$DB_NAME" < "$DIR/documentserver/Schema/MySql.CreateDb.sql"
  
  echo "OK"
}

establish_db_conn() {
	echo -n "Trying to establish MySQL connection... "

	command -v mysql >/dev/null 2>&1 || { echo "MySQL client not found"; exit 1; }

	MYSQL="mysql -h$DB_HOST -u$DB_USER"
	if [ -n "$DB_PWD" ]; then
		MYSQL="$MYSQL -p$DB_PWD"
	fi

	$MYSQL -e ";" >/dev/null 2>&1
	ERRCODE=$?
	if [ $ERRCODE -ne 0 ]; then
		systemctl mysqld start >/dev/null 2>&1
		$MYSQL -e ";" >/dev/null 2>&1 || { echo "FAILURE"; exit 1; }
	fi

	echo "OK"
}

read_db_params
establish_db_conn || exit $?
execute_db_scripts || exit $?
save_db_params
restart_services