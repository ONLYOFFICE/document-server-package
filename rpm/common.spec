%define __strip    /bin/true
Summary: %{_package_summary}
Name: %{_package_name}
Version: %{_product_version}
Release: %{_build_number}
Group: Applications/Internet
URL: %{_publisher_url}
Vendor: %{_publisher_name}
Packager: %{_publisher_name} <%{_support_mail}>
AutoReq: no
AutoProv: no

%description
%{_package_description}

%prep
rm -rf "%{buildroot}"

%build

%install

DOCUMENTSERVER_BIN=%{_builddir}/../../../common/documentserver/bin
DOCUMENTSERVER_HOME=%{_builddir}/../../../common/documentserver/home
DOCUMENTSERVER_CONFIG=%{_builddir}/../../../common/documentserver/config

DOCUMENTSERVER_EXAMPLE_HOME=%{_builddir}/../../../common/documentserver-example/home
DOCUMENTSERVER_EXAMPLE_CONFIG=%{_builddir}/../../../common/documentserver-example/config

BIN_DIR=%{buildroot}%{_bindir}
DATA_DIR=%{buildroot}%{_localstatedir}/lib/%{_ds_prefix}
CONF_DIR=%{buildroot}%{_sysconfdir}/%{_ds_prefix}
HOME_DIR=%{buildroot}%{_localstatedir}/www/%{_ds_prefix}
LIB_DIR=%{buildroot}%{_libdir}
LOG_DIR=%{buildroot}%{_localstatedir}/log/%{_ds_prefix}

#install documentserver files
mkdir -p "$HOME_DIR/"
cp -r $DOCUMENTSERVER_HOME/* "$HOME_DIR/"

#install documentserver libs
mkdir -p "$LIB_DIR/"
cp -r $DOCUMENTSERVER_HOME/server/FileConverter/bin/*.so* "$LIB_DIR/" 
rm $HOME_DIR/server/FileConverter/bin/*.so*

#install documentserver bin
mkdir -p "$BIN_DIR/"
cp -r $DOCUMENTSERVER_BIN/*.sh "$BIN_DIR/"
cp -r %{_builddir}/../../bin/*.sh "$BIN_DIR/"

#install configs
mkdir -p "$CONF_DIR/"
cp -r $DOCUMENTSERVER_CONFIG/* "$CONF_DIR/" 

#make log dir
mkdir -p "$LOG_DIR/docservice"
mkdir -p "$LOG_DIR/converter"
mkdir -p "$LOG_DIR/metrics"

#make cache dir
mkdir -p "$DATA_DIR/App_Data/cache/files"
mkdir -p "$DATA_DIR/App_Data/docbuilder"

#make exchange dir
mkdir -p "$HOME_DIR/fonts"

#install systemd services
mkdir -p %{buildroot}/usr/lib/systemd/system
cp %{_builddir}/../../../common/documentserver/systemd/*.service %{buildroot}/usr/lib/systemd/system

#install nginx config
DS_NGINX_CONF=$CONF_DIR/nginx/
mkdir -p "$DS_NGINX_CONF"
mkdir -p "$DS_NGINX_CONF/includes/"

cp -r %{_builddir}/../../../common/documentserver/nginx/*.conf "$DS_NGINX_CONF"
cp -r %{_builddir}/../../../common/documentserver/nginx/*.tmpl "$DS_NGINX_CONF"
cp -r %{_builddir}/../../../common/documentserver/nginx/includes/*.conf "$DS_NGINX_CONF/includes/"

mkdir -p "%{buildroot}%{_localstatedir}/cache/nginx/%{_ds_prefix}/"

mkdir -p "%{buildroot}%{_sysconfdir}/nginx/includes/"
mkdir -p "%{buildroot}%{_sysconfdir}/nginx/%{nginx_conf_d}/"

#install logrotate config
DS_LOGROTATE_CONF=$CONF_DIR/logrotate/
mkdir -p "$DS_LOGROTATE_CONF"
cp -r %{_builddir}/../../../common/documentserver/logrotate/*.conf "$DS_LOGROTATE_CONF"

%if %{defined example}
#install documentserver example files
mkdir -p "${HOME_DIR}-example/"
cp -r $DOCUMENTSERVER_EXAMPLE_HOME/* "${HOME_DIR}-example/"

#install dcoumentserver example configs
mkdir -p "${CONF_DIR}-example/"
cp -r $DOCUMENTSERVER_EXAMPLE_CONFIG/* "${CONF_DIR}-example/" 

#make log dir
mkdir -p "${LOG_DIR}-example"

# create data dir
mkdir -p "${DATA_DIR}-example/files/"

#install example systemd services
cp %{_builddir}/../../../common/documentserver-example/systemd/*.service %{buildroot}/usr/lib/systemd/system

#install nginx config
DSE_NGINX_CONF=${CONF_DIR}-example/nginx/includes/
mkdir -p "$DSE_NGINX_CONF"
cp -r %{_builddir}/../../../common/documentserver-example/nginx/includes/*.conf "$DSE_NGINX_CONF"
%endif

# Make symlinks for nginx configs
find \
  ${CONF_DIR}*/nginx/includes \
  -name *.conf \
  -exec sh -c '%__ln_s {} %{buildroot}%{_sysconfdir}/nginx/includes/$(basename {})' \;

%__ln_s \
  $CONF_DIR/nginx/ds.conf \
  %{buildroot}%{_sysconfdir}/nginx/%{nginx_conf_d}/ds.conf

mkdir -p "%{buildroot}%{_sysconfdir}/logrotate.d/"

# Make symlinks for logrotate configs
find \
  $CONF_DIR/logrotate/ \
  -name *.conf \
  -exec sh -c '%__ln_s {} %{buildroot}%{_sysconfdir}/logrotate.d/$(basename {})' \;

# Convert absolute links to relative links
symlinks -c \
  %{buildroot}%{_sysconfdir}/nginx/%{nginx_conf_d} \
  %{buildroot}%{_sysconfdir}/nginx/includes \
  %{buildroot}%{_sysconfdir}/logrotate.d 

%if %{defined example}
# index.html for rpm
sed 's/linux.html/linux-rpm.html/g' -i "$DSE_NGINX_CONF/ds-example.conf"
%endif

%clean
rm -rf "%{buildroot}"

%files

%defattr(440, ds, ds, 555)
%{_localstatedir}/www/%{_ds_prefix}*/*

%attr(550, ds, ds) %{_localstatedir}/www/%{_ds_prefix}/npm/json
%attr(550, ds, ds) %{_localstatedir}/www/%{_ds_prefix}/server/DocService/docservice
%attr(550, ds, ds) %{_localstatedir}/www/%{_ds_prefix}/server/FileConverter/converter
%attr(550, ds, ds) %{_localstatedir}/www/%{_ds_prefix}/server/FileConverter/bin/docbuilder
%attr(550, ds, ds) %{_localstatedir}/www/%{_ds_prefix}/server/FileConverter/bin/x2t
%attr(550, ds, ds) %{_localstatedir}/www/%{_ds_prefix}/server/Metrics/metrics
%attr(550, ds, ds) %{_localstatedir}/www/%{_ds_prefix}/server/Metrics/node_modules/modern-syslog/build/Release/core.node
%attr(550, ds, ds) %{_localstatedir}/www/%{_ds_prefix}/server/tools/*
%if %{defined example}
%attr(550, ds, ds) %{_localstatedir}/www/%{_ds_prefix}-example/example
%endif

%config %{_sysconfdir}/%{_ds_prefix}*/*.json
%config %{_sysconfdir}/%{_ds_prefix}*/log4js/*.json

%config %{_sysconfdir}/%{_ds_prefix}*/nginx/includes/*
%config %{_sysconfdir}/%{_ds_prefix}/nginx/*.tmpl

%config(noreplace) %{_sysconfdir}/%{_ds_prefix}/nginx/ds.conf

%config %attr(644, root, root) %{_sysconfdir}/%{_ds_prefix}/logrotate/*

%attr(755, root, root) %{_libdir}/*.so*
%attr(744, root, root) %{_bindir}/documentserver-*.sh
%attr(-, root, root) %{_sysconfdir}/logrotate.d/*
%attr(-, root, root) %{_sysconfdir}/nginx/%{nginx_conf_d}/*
%attr(-, root, root) %{_sysconfdir}/nginx/includes/*
%attr(644, root, root) /usr/lib/systemd/system/*

%dir
%attr(750, %{nginx_user}, %{nginx_user}) %{_localstatedir}/cache/nginx/%{_ds_prefix}
%attr(755, ds, ds) %{_localstatedir}/log/%{_ds_prefix}

%attr(750, ds, ds) %{_localstatedir}/lib/%{_ds_prefix}

%if %{defined example}
%attr(755, ds, ds) %{_localstatedir}/log/%{_ds_prefix}-example
%attr(750, ds, ds) %{_localstatedir}/lib/%{_ds_prefix}-example
%endif

%pre
# add group and user for onlyoffice app
getent group ds >/dev/null || groupadd -r ds
getent passwd ds >/dev/null || useradd -r -g ds -d %{_localstatedir}/www/%{_ds_prefix}/ -s /sbin/nologin ds
# add nginx user to onlyoffice group to allow access nginx to onlyoffice log dir
usermod -a -G ds %{nginx_user}

case "$1" in
  1)
    # Initial installation
  ;;
  2)
    # Upgrade
    # disconnect all users and stop running services
    documentserver-prepare4shutdown.sh || true

    echo "Stopping documentserver services..."
    for SVC in %{package_services}; do
      if [ -e /usr/lib/systemd/system/$SVC.service ]; then
        systemctl stop $SVC
      fi
    done
  ;;
esac
exit 0

%post
# Make symlink to libcurl-gnutls
ln -sf %{_libdir}/libcurl.so.4 %{_libdir}/libcurl-gnutls.so.4

#make exchange dir
DATA_DIR="%{_localstatedir}/www/%{_ds_prefix}/../Data"
if [ ! -d "${DATA_DIR}" ]; then
  mkdir -m 755 -p "${DATA_DIR}"
  chown ds:ds "${DATA_DIR}"
fi

chown -R ds:ds %{_localstatedir}/lib/%{_ds_prefix}

%if %{defined example}
chown -R ds:ds %{_localstatedir}/lib/%{_ds_prefix}-example
%endif

IS_UPGRADE="false"

case "$1" in
  1)
    # Initial installation
  ;;
  2)
    # Upgrade database
    IS_UPGRADE="true"
  ;;
esac

if [ "$IS_UPGRADE" = "true" ]; then
  NGINX_CONF=%{_sysconfdir}/%{_ds_prefix}/nginx/ds.conf
  if [ -e $NGINX_CONF ] && ! grep -q secure_link_secret $NGINX_CONF; then
	  sed '/server_tokens/a \ \ set $secure_link_secret verysecretstring;' -i $NGINX_CONF
  fi

  chown ds:ds %{_localstatedir}/log/%{_ds_prefix}/**/*.log

  %if %{defined example}
    chown -R ds:ds %{_localstatedir}/log/%{_ds_prefix}-example
  %endif

  DIR="/var/www/%{_ds_prefix}"
  LOCAL_CONFIG="/etc/%{_ds_prefix}/local.json"
  JSON_BIN="$DIR/npm/json"
  JSON="$JSON_BIN -f $LOCAL_CONFIG"

  JWT_ENABLED=$($JSON services.CoAuthoring.token.enable.request.inbox)
  if [ $JWT_ENABLED = "false" ]; then
    JWT_MESSAGE="You have JWT disabled. We recommend enabling JWT in ${LOCAL_CONFIG} in services.CoAuthoring.token.enable and configure your custom JWT key in services.CoAuthoring.secret"
  fi

  if [ -f ${LOCAL_CONFIG} ] && [[ -n "$($JSON services.CoAuthoring.sql)" ]]; then
    #load_db_params
    DB_HOST=$($JSON services.CoAuthoring.sql.dbHost)
    DB_NAME=$($JSON services.CoAuthoring.sql.dbName)
    DB_USER=$($JSON services.CoAuthoring.sql.dbUser)
    DB_PWD=$($JSON services.CoAuthoring.sql.dbPass)
    DB_TYPE=$($JSON services.CoAuthoring.sql.type)
    DB_PORT=$($JSON services.CoAuthoring.sql.dbPort)

    case $DB_TYPE in
      postgres)
        echo -n "Trying to establish PostgreSQL connection... "
        command -v psql >/dev/null 2>&1 || { echo "PostgreSQL client not found"; exit 1; }
        CONNECTION_PARAMS="-h$DB_HOST -U$DB_USER -w"
        if [ -n "$DB_PWD" ]; then
          export PGPASSWORD=$DB_PWD
        fi
        PSQL="psql -q $CONNECTION_PARAMS"
        $PSQL -c ";" >/dev/null 2>&1 || { echo "FAILURE"; exit 1; }
        echo "OK"

        echo -n "Updating PostgreSQL database... "
        $PSQL -d "$DB_NAME" -f "$DIR/server/schema/postgresql/removetbl.sql" >/dev/null 2>&1
        $PSQL -d "$DB_NAME" -f "$DIR/server/schema/postgresql/createdb.sql" >/dev/null 2>&1
        echo "OK"
        ;;

      mysql)
        echo -n "Trying to database MySQL connection... "
        command -v mysql >/dev/null 2>&1 || { echo "MySQL client not found"; exit 1; }
        MYSQL="mysql -h$DB_HOST -u$DB_USER"
        if [ -n "$DB_PWD" ]; then
          MYSQL="$MYSQL -p$DB_PWD"
        fi
        $MYSQL -e ";" >/dev/null 2>&1 || { echo "FAILURE"; exit 1; }
        echo "OK"

        echo -n "Updating MYSQL database... "
        $MYSQL "$DB_NAME" < "$DIR/server/schema/mysql/removetbl.sql"
        $MYSQL "$DB_NAME" < "$DIR/server/schema/mysql/createdb.sql"
        echo "OK"
        ;;

      *)
        echo "Incorrect DB_TYPE value! Possible value of DB_TYPE is 'postgres' or 'mysql'."
        exit 1
    esac
  else
    echo ""
    echo "Update of %{_package_name} ended with a problem"
    echo "You should reconfigure the package using script \"/usr/bin/documentserver-configure.sh\""
    echo ""
  fi
fi

# generate allfonts.js and thumbnail
rpm_version=$(rpm -q --qf '%%{version}' rpm | awk -F. '{ printf("%%d%%03d%%03d%%03d", $1,$2,$3,$4); }';)
if [[ "$rpm_version" -lt "4013001000" ]]; then
  documentserver-generate-allfonts.sh true
fi

# check whethere enabled
shopt -s nocasematch
PORTS=()
case $(%{getenforce}) in
  enforcing|permissive)
    PORTS+=('8000')
    PORTS+=('3000')
    %{setsebool} -P httpd_can_network_connect on
  ;;
  disabled)
    :
  ;;
esac

# add selinux extentions
for PORT in ${PORTS[@]}; do
  %{semanage} port -a -t http_port_t -p tcp $PORT >/dev/null 2>&1 || \
    %{semanage} port -m -t http_port_t -p tcp $PORT >/dev/null 2>&1 || \
    true
done

#restart dependent services
systemctl daemon-reload
for SVC in %{package_services}; do
  if [ -e /usr/lib/systemd/system/$SVC.service ]; then
    systemctl enable $SVC
    systemctl restart $SVC
  fi
done

if systemctl is-active --quiet nginx; then
  systemctl reload nginx >/dev/null 2>&1
fi

echo "$JWT_MESSAGE"

%transfiletriggerin -- /usr/share/fonts /usr/share/ghostscript/fonts /usr/share/texmf/fonts
%{_bindir}/documentserver-generate-allfonts.sh true

%transfiletriggerun -- /usr/share/fonts /usr/share/ghostscript/fonts /usr/share/texmf/fonts
%{_bindir}/documentserver-generate-allfonts.sh true

%preun
case "$1" in
  0)
    # Uninstall
    # disconnect all users and stop running services
    documentserver-prepare4shutdown.sh
    for SVC in %{package_services}; do
      if [ -e /usr/lib/systemd/system/$SVC.service ]; then
        systemctl stop $SVC
      fi
    done
  ;;
  1)
    # Upgrade
    :
  ;;
esac

%postun
DIR="%{_localstatedir}/www/%{_ds_prefix}"

# remove v8 cache
rm -f $DIR/sdkjs/*/sdk-all.cache

case "$1" in
  0)
    # Uninstall
    rm -f $DIR/sdkjs/common/AllFonts.js
    rm -f $DIR/sdkjs/common/Images/fonts_thumbnail*
    rm -f $DIR/sdkjs/*/sdk-all.cache
    rm -f $DIR/server/FileConverter/bin/font_selection.bin
    rm -f $DIR/server/FileConverter/bin/AllFonts.js
    rm -f $DIR/fonts/*
  ;;
  1)
    # Upgrade
    :
  ;;
esac

if systemctl is-active --quiet nginx; then
  systemctl reload nginx >/dev/null 2>&1
fi

%changelog
