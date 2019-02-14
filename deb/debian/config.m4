#!/bin/sh

set -e

. /usr/share/debconf/confmodule

DB_HOST=""
DB_NAME=""
DB_USER=""
DB_PWD=""

db_fset M4_ONLYOFFICE_VALUE/cluster-mode seen true
db_fset M4_ONLYOFFICE_VALUE/ds-port seen true
db_fset M4_ONLYOFFICE_VALUE/docservice-port seen true
db_fset M4_ONLYOFFICE_VALUE/spellchecker-port seen true
db_fset M4_ONLYOFFICE_VALUE/example-port seen true
db_fset M4_ONLYOFFICE_VALUE/jwt-enabled seen true
db_fset M4_ONLYOFFICE_VALUE/jwt-secret seen true
db_fset M4_ONLYOFFICE_VALUE/jwt-header seen true

db_input medium M4_ONLYOFFICE_VALUE/db-host || true
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

db_get M4_ONLYOFFICE_VALUE/db-host
DB_HOST="$RET"

db_get M4_ONLYOFFICE_VALUE/db-name
DB_NAME="$RET"

db_get M4_ONLYOFFICE_VALUE/db-user
DB_USER="$RET"

db_get M4_ONLYOFFICE_VALUE/db-pwd
DB_PWD="$RET"

exit 0
