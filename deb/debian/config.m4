#!/bin/sh

set -e

. /usr/share/debconf/confmodule

DB_TYPE=""
DB_HOST=""
DB_PORT=""
DB_NAME=""
DB_USER=""
DB_PWD=""

db_fset M4_ONLYOFFICE_VALUE/db-type seen true
db_fset M4_ONLYOFFICE_VALUE/cluster-mode seen true
db_fset M4_ONLYOFFICE_VALUE/ds-port seen true
db_fset M4_ONLYOFFICE_VALUE/docservice-port seen true
db_fset M4_ONLYOFFICE_VALUE/spellchecker-port seen true
db_fset M4_ONLYOFFICE_VALUE/example-port seen true
db_fset M4_ONLYOFFICE_VALUE/jwt-enabled seen true
db_fset M4_ONLYOFFICE_VALUE/jwt-secret seen true
db_fset M4_ONLYOFFICE_VALUE/jwt-header seen true

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

ifelse(eval(ifelse(M4_PRODUCT_NAME,documentserver-ie,1,0)||ifelse(M4_PRODUCT_NAME,documentserver-de,1,0)),1,
db_input medium M4_ONLYOFFICE_VALUE/redis-host || true
,)dnl
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

exit 0
