Summary: Online viewers and editors for text, spreadsheet and presentation files
Name: %{_package_name}
Version: %{_product_version}
Release: %{_build_number}
Group: Applications/Internet
URL: %{_publisher_url}
Vendor: %{_publisher_name}
Packager: %{_publisher_name} <%{_support_mail}>
BuildArch: x86_64
AutoReq: no
AutoProv: no

%description
Free open source office suite and business productivity tools in one solution:
online document editors, file and project management, CRM

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
mkdir -p "$LOG_DIR/spellchecker"
mkdir -p "$LOG_DIR/metrics"
mkdir -p "$LOG_DIR/gc"

#make cache dir
mkdir -p "$DATA_DIR/App_Data/cache/files"
mkdir -p "$DATA_DIR/App_Data/docbuilder"

#make exchange dir
mkdir -p "%{buildroot}%{_localstatedir}/www/%{_ds_prefix}/../Data"

#make exchange dir
mkdir -p "$HOME_DIR/fonts"

#install supervisor configs
DS_SUPERVISOR_CONF=$CONF_DIR/supervisor/
mkdir -p "$DS_SUPERVISOR_CONF"
cp %{_builddir}/../../../common/documentserver/supervisor/* "$DS_SUPERVISOR_CONF"

# rename extention for supervisor config files
rename 's/.conf$/.ini/' "$DS_SUPERVISOR_CONF"*

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
cp -r %{_builddir}/../../../common/documentserver/logrotate/* "$DS_LOGROTATE_CONF"

%if %{defined example}
#install documentserver example files
mkdir -p "${HOME_DIR}-example/"
cp -r $DOCUMENTSERVER_EXAMPLE_HOME/* "${HOME_DIR}-example/"

#install dcoumentserver example configs
mkdir -p "${CONF_DIR}-example/"
cp -r $DOCUMENTSERVER_EXAMPLE_CONFIG/* "${CONF_DIR}-example/" 

#make log dir
mkdir -p "${LOG_DIR}-example"

#install example supervisor configs
DSE_SUPERVISOR_CONF=${CONF_DIR}-example/supervisor/
mkdir -p "$DSE_SUPERVISOR_CONF"
cp %{_builddir}/../../../common/documentserver-example/supervisor/* "$DSE_SUPERVISOR_CONF"

# rename extention for supervisor config files
rename 's/.conf$/.ini/' "$DSE_SUPERVISOR_CONF"*

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

mkdir -p "%{buildroot}%{_sysconfdir}/supervisord.d/"

# Make symlinks for supervisor configs
find \
  ${CONF_DIR}*/supervisor/ \
  -name *.ini \
  -exec sh -c '%__ln_s {} %{buildroot}%{_sysconfdir}/supervisord.d/$(basename {})' \;

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
  %{buildroot}%{_sysconfdir}/supervisord.d \
  %{buildroot}%{_sysconfdir}/logrotate.d 

%clean
rm -rf "%{buildroot}"

%files
%attr(-, ds, ds) %{_localstatedir}/www/%{_ds_prefix}*/*
%config %attr(440, ds, ds) %{_sysconfdir}/%{_ds_prefix}*/*.json
%config %attr(440, ds, ds) %{_sysconfdir}/%{_ds_prefix}*/log4js/*.json

%config %attr(-, ds, ds) %{_sysconfdir}/%{_ds_prefix}*/nginx/includes/*
%config %attr(-, ds, ds) %{_sysconfdir}/%{_ds_prefix}/nginx/*.tmpl

%config(noreplace) %{_sysconfdir}/%{_ds_prefix}/nginx/ds.conf

%config %attr(644, root, root) %{_sysconfdir}/%{_ds_prefix}/logrotate/*
%config %attr(-, ds, ds) %{_sysconfdir}/%{_ds_prefix}*/supervisor*/*

%attr(-, root, root) %{_libdir}/*.so*
%attr(-, root, root) %{_bindir}/documentserver-*.sh
%attr(-, root, root) %{_sysconfdir}/logrotate.d/*
%attr(-, root, root) %{_sysconfdir}/nginx/*
%attr(-, root, root) %{_sysconfdir}/supervisord.d/*

%dir
%attr(-, %{nginx_user}, %{nginx_user}) %{_localstatedir}/cache/nginx/%{_ds_prefix}
%attr(755, ds, ds) %{_localstatedir}/log/%{_ds_prefix}

%attr(-, ds, ds) %{_localstatedir}/lib/%{_ds_prefix}
%attr(755, -, -) %{_localstatedir}/www/%{_ds_prefix}/../Data

%if %{defined example}
%attr(-, ds, ds) %{_localstatedir}/log/%{_ds_prefix}-example
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
    for i in ds onlyoffice; do
      if [ $(supervisorctl avail | grep ${i} | wc -l) -gt 0 ]; then
        echo "Stopping documentserver services..."
        supervisorctl stop ${i}:*
      fi
    done
  ;;
esac
exit 0

%post
# Make symlink to libcurl-gnutls
ln -sf %{_libdir}/libcurl.so.4 %{_libdir}/libcurl-gnutls.so.4

# generate allfonts.js and thumbnail
documentserver-generate-allfonts.sh true

# check whethere enabled
shopt -s nocasematch
PORTS=()
case $(%{getenforce}) in
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
  %{semanage} port -a -t http_port_t -p tcp $PORT >/dev/null 2>&1 || \
    %{semanage} port -m -t http_port_t -p tcp $PORT >/dev/null 2>&1 || \
    true
done

# restart dependent services
if systemctl is-active --quiet supervisord; then
  systemctl restart supervisord >/dev/null 2>&1
fi

if systemctl is-active --quiet nginx; then
  systemctl reload nginx >/dev/null 2>&1
fi

%preun
case "$1" in
  0)
    # Uninstall
    # disconnect all users and stop running services
    documentserver-prepare4shutdown.sh
    if systemctl is-active --quiet supervisord; then
      supervisorctl stop ds:*
    fi
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
    
    if systemctl is-active --quiet supervisord; then
      supervisorctl update >/dev/null 2>&1
    fi
    
    if systemctl is-active --quiet nginx; then
      systemctl reload nginx >/dev/null 2>&1
    fi
  ;;
  1)
    # Upgrade
    :
  ;;
esac

%changelog
