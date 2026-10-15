#!/bin/sh

set -e

. /usr/share/debconf/confmodule

DB_TYPE=""
DB_HOST=""
DB_PORT=""
DB_NAME=""
DB_USER=""
DB_PWD=""

db_fset M4_ONLYOFFICE_VALUE/jwt-enabled seen true
db_fset M4_ONLYOFFICE_VALUE/jwt-secret seen true
db_fset M4_ONLYOFFICE_VALUE/jwt-header seen true
db_fset M4_ONLYOFFICE_VALUE/wopi-enabled seen true

db_get M4_ONLYOFFICE_VALUE/listenaddress
LISTEN_ADDRESS="$RET"
# (Docs v10.0.0) keep a real listenaddress; only derive from ds.conf/ds-port when it's still the default
if [ "$LISTEN_ADDRESS" = "0.0.0.0:M4_DS_DEFAULT_PORT" ]; then
	LISTEN_ADDRESS=""
	if [ -f /etc/M4_DS_PREFIX/nginx/ds.conf ]; then
		LISTEN_ADDRESS=$(sed -n 's/^[[:space:]]*listen[[:space:]]\+\([0-9.]\+:[0-9]\+\).*;/\1/p' /etc/M4_DS_PREFIX/nginx/ds.conf | head -n 1)
	fi
	if [ -z "$LISTEN_ADDRESS" ]; then
		db_fget M4_ONLYOFFICE_VALUE/ds-port seen
		if [ "$RET" = true ]; then
			db_get M4_ONLYOFFICE_VALUE/ds-port
			LISTEN_ADDRESS="0.0.0.0:$RET"
		fi
	fi
fi
LISTEN_ADDRESS="${LISTEN_ADDRESS:-0.0.0.0:M4_DS_DEFAULT_PORT}"

db_set M4_ONLYOFFICE_VALUE/listenaddress "$LISTEN_ADDRESS"
db_set M4_ONLYOFFICE_VALUE/ds-port "${LISTEN_ADDRESS##*:}"
db_fset M4_ONLYOFFICE_VALUE/listenaddress seen false
db_fset M4_ONLYOFFICE_VALUE/ds-port seen false

ifelse(regexp(M4_PACKAGE_NAME,`documentserver$'),-1,
`db_fset M4_ONLYOFFICE_VALUE/db-type seen true
db_fset M4_ONLYOFFICE_VALUE/cluster-mode seen true
db_input medium M4_ONLYOFFICE_VALUE/db-type || true
db_input medium M4_ONLYOFFICE_VALUE/db-host || true
db_input medium M4_ONLYOFFICE_VALUE/db-port || true
db_input medium M4_ONLYOFFICE_VALUE/db-name || true
db_input medium M4_ONLYOFFICE_VALUE/db-user || true
db_go

db_input critical M4_ONLYOFFICE_VALUE/db-pwd || true
db_go

db_input medium M4_ONLYOFFICE_VALUE/rabbitmq-host || true
db_input medium M4_ONLYOFFICE_VALUE/rabbitmq-user || true
db_input medium M4_ONLYOFFICE_VALUE/rabbitmq-pwd || true
db_input medium M4_ONLYOFFICE_VALUE/redis-host || true
db_go

db_get M4_ONLYOFFICE_VALUE/db-type
DB_TYPE="$RET"

db_get M4_ONLYOFFICE_VALUE/db-host
DB_HOST="$RET"

db_get M4_ONLYOFFICE_VALUE/db-port
DB_PORT="$RET"

db_get M4_ONLYOFFICE_VALUE/db-name
DB_NAME="$RET"

db_get M4_ONLYOFFICE_VALUE/db-user
DB_USER="$RET"

db_get M4_ONLYOFFICE_VALUE/db-pwd
DB_PWD="$RET"
',)dnl

exit 0
