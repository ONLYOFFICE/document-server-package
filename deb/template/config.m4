#!/bin/sh

set -e

. /usr/share/debconf/confmodule

DB_TYPE=""
DB_HOST=""
DB_PORT=""
DB_NAME=""
DB_USER=""
DB_PWD=""

db_fset M4_ONLYOFFICE_VALUE/ds-port seen true
db_fset M4_ONLYOFFICE_VALUE/jwt-enabled seen true
db_fset M4_ONLYOFFICE_VALUE/jwt-secret seen true
db_fset M4_ONLYOFFICE_VALUE/jwt-header seen true
db_fset M4_ONLYOFFICE_VALUE/wopi-enabled seen true

db_get M4_ONLYOFFICE_VALUE/ds-port
DS_PORT="$RET"
if [ "$1" = configure ] && [ -f /etc/M4_DS_PREFIX/nginx/ds.conf ]; then
	DS_PORT=$(sed -n 's/^[[:space:]]*listen .*:\([0-9]\{2,5\}\).*/\1/p' /etc/M4_DS_PREFIX/nginx/ds.conf | head -n 1)
fi
db_set M4_ONLYOFFICE_VALUE/ds-port "${DS_PORT:-$RET}"

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
