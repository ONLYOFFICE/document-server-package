#!/bin/sh
# postrm script for M4_ONLYOFFICE_VALUE
#
# see: dh_installdeb(1)

set -e

# summary of how this script can be called:
#        * <postrm> `remove'
#        * <postrm> `purge'
#        * <old-postrm> `upgrade' <new-version>
#        * <new-postrm> `failed-upgrade' <old-version>
#        * <new-postrm> `abort-install'
#        * <new-postrm> `abort-install' <old-version>
#        * <new-postrm> `abort-upgrade' <old-version>
#        * <disappearer's-postrm> `disappear' <overwriter>
#          <overwriter-version>
# for details, see http://www.debian.org/doc/debian-policy/ or
# the debian-policy package

if [ "$1" = purge ] && [ -e /usr/share/debconf/confmodule ]; then
. /usr/share/debconf/confmodule
fi

remove_postgres() {
	CONNECTION_PARAMS="-h$DB_HOST -p${DB_PORT:="5432"} -U$DB_USER -w"
	if [ -n $DB_PWD ]; then
		export PGPASSWORD="$DB_PWD"
	fi
	psql $CONNECTION_PARAMS $DB_NAME -t -c "DROP SCHEMA IF EXISTS public CASCADE;" &>/dev/null || \
		{ echo "WARNING: can't delete M4_ONLYOFFICE_VALUE database tables" >&2; }
}

remove_mysql() {
	CONNECTION_PARAMS="-h$DB_HOST -P${DB_PORT:="3306"} -u$DB_USER -p$DB_PWD -w"
	MYSQL="mysql -q $CONNECTION_PARAMS"
	$MYSQL -e \
		"DROP DATABASE IF EXISTS $DB_NAME;" &>/dev/null || \
		{ echo "WARNING: can't delete M4_ONLYOFFICE_VALUE database" >&2; }
}

clean_ds_files() {
	DIR="/var/www/M4_DS_PREFIX"
	LOG_DIR="/var/log/M4_DS_PREFIX"
	APP_DIR="/var/lib/M4_DS_PREFIX"
	rm -f $DIR/sdkjs/common/AllFonts.js
	rm -f $DIR/sdkjs/common/Images/fonts_thumbnail*
	rm -f $DIR/sdkjs/*/sdk-all.cache
	rm -f $DIR/server/FileConverter/bin/font_selection.bin
	rm -f $DIR/server/FileConverter/bin/AllFonts.js
	rm -fr $DIR/fonts

    if [ -d /etc/nginx/conf.d/ ] && [ -e /etc/nginx/conf.d/ds.conf ]; then
	  rm -f /etc/nginx/conf.d/ds.conf
    fi

    CONF_DIR="/etc/M4_DS_PREFIX"
	if [ -d /etc/nginx/conf.d/ ] && [ -e $CONF_DIR/dse/dse.conf ] && [ -f $DIR-example/example ]; then
      mv $CONF_DIR/dse/dse.conf /etc/nginx/conf.d/
	fi
	rm -fr $CONF_DIR/dse

	service nginx reload >/dev/null 2>&1
}

case "$1" in
	purge)
		clean_ds_files

		# purge logs
		if [ -d $LOG_DIR ]; then
			rm -rf $LOG_DIR
		fi

    # purge files
		if [ -d $APP_DIR ]; then
			rm -rf 	$APP_DIR
		fi

		# purge plugins
		if [ -d $DIR/sdkjs-plugins/ ]; then
			rm -rf $DIR/sdkjs-plugins/
		fi

		db_input high M4_ONLYOFFICE_VALUE/remove-db || true
		db_go
		db_get M4_ONLYOFFICE_VALUE/remove-db
		if [ "$RET" = "true" ]; then
			db_get M4_ONLYOFFICE_VALUE/db-type
			DB_TYPE="$RET"
			db_get M4_ONLYOFFICE_VALUE/db-host
			DB_HOST="$RET"
			db_get M4_ONLYOFFICE_VALUE/db-port
			DB_PORT="$RET"
			db_get M4_ONLYOFFICE_VALUE/db-user
			DB_USER="$RET"
			db_get M4_ONLYOFFICE_VALUE/db-pwd
			DB_PWD="$RET"
			db_get M4_ONLYOFFICE_VALUE/db-name
			DB_NAME="$RET"
			case $DB_TYPE in
				"postgres")
					remove_postgres
					;;
				"mariadb"|"mysql")
					remove_mysql
					;;
				*)
					echo "ERROR: unknown database type"
					exit 1
					;;
			esac
		fi
	;;

	remove|upgrade)
		clean_ds_files
	;;
  
	failed-upgrade|abort-install|abort-upgrade|disappear)
  	:
	;;

	*)
		echo "postrm called with unknown argument \`$1'" >&2
		exit 1
	;;
esac

# dh_installdeb will replace this with shell code automatically
# generated by other debhelper scripts.

#DEBHELPER#

exit 0
