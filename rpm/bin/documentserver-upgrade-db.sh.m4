#!/bin/bash

DIR="/var/www/M4_DS_PREFIX"
LOCAL_CONFIG="/etc/M4_DS_PREFIX/local.json"
JSON_BIN="$DIR/npm/json"
JSON="$JSON_BIN -f $LOCAL_CONFIG"

load_db_params(){
	DB_HOST=$($JSON services.CoAuthoring.sql.dbHost)
	DB_NAME=$($JSON services.CoAuthoring.sql.dbName)
	DB_USER=$($JSON services.CoAuthoring.sql.dbUser)
	DB_PWD=$($JSON services.CoAuthoring.sql.dbPass)
	DB_TYPE=$($JSON services.CoAuthoring.sql.type)
	DB_PORT=$($JSON services.CoAuthoring.sql.dbPort)
}

execute_postgres_scripts(){
	echo -n "Updating PostgreSQL database... "

	$PSQL -d "$DB_NAME" -f "$DIR/server/schema/postgresql/removetbl.sql" >/dev/null 2>&1
	$PSQL -d "$DB_NAME" -f "$DIR/server/schema/postgresql/createdb.sql" >/dev/null 2>&1

	echo "OK"
}

establish_postgres_conn() {
	echo -n "Trying to establish PostgreSQL connection... "

	command -v psql >/dev/null 2>&1 || { echo "PostgreSQL client not found"; exit 1; }

        CONNECTION_PARAMS="-h$DB_HOST -U$DB_USER -w"
        if [ -n "$DB_PWD" ]; then
                export PGPASSWORD=$DB_PWD
        fi

        PSQL="psql -q $CONNECTION_PARAMS"

	$PSQL -c ";" >/dev/null 2>&1 || { echo "FAILURE"; exit 1; }

	echo "OK"
}

execute_mysql_sqript(){
	echo -n "Updating MYSQL database... "

	$MYSQL "$DB_NAME" < "$DIR/server/schema/mysql/removetbl.sql"
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
			establish_postgres_conn || exit $?
			execute_postgres_scripts || exit $?
			;;	
		mysql) 
			establish_mysql_conn || exit $?
			execute_mysql_sqript || exit $?
			;;   
		*)
			echo "Incorrect DB_TYPE value! Possible value of DB_TYPE is 'postgres' or 'mysql'."
			exit 1	  
	esac
}

load_db_params
execute_db_script
