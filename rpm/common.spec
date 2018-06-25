Summary: Online viewers and editors for text, spreadsheet and presentation files
Name: %{_package_name}
Version: %{_product_version}
Release: %{_build_number}
Group: Applications/Internet
URL: http://onlyoffice.com/
Vendor: ONLYOFFICE (Online documents editor)
Packager: ONLYOFFICE (Online documents editor) <support@onlyoffice.com>
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

#install documentserver files
mkdir -p "%{buildroot}/var/www/onlyoffice/documentserver/"
cp -r $DOCUMENTSERVER_HOME/* "%{buildroot}/var/www/onlyoffice/documentserver/"

#install documentserver libs
mkdir -p "%{buildroot}/usr/lib64/"
cp -r $DOCUMENTSERVER_HOME/server/FileConverter/bin/*.so* "%{buildroot}/usr/lib64/" 
rm "%{buildroot}"/var/www/onlyoffice/documentserver/server/FileConverter/bin/*.so*

#install documentserver bin
mkdir -p "%{buildroot}/usr/bin/"
cp -r $DOCUMENTSERVER_BIN/*.sh "%{buildroot}/usr/bin/"
cp -r %{_builddir}/../../bin/*.sh "%{buildroot}/usr/bin/"

#install configs
mkdir -p "%{buildroot}/etc/onlyoffice/documentserver/"
cp -r $DOCUMENTSERVER_CONFIG/* "%{buildroot}/etc/onlyoffice/documentserver/" 

#make log dir
mkdir -p "%{buildroot}/var/log/onlyoffice/documentserver/docservice"
mkdir -p "%{buildroot}/var/log/onlyoffice/documentserver/converter"
mkdir -p "%{buildroot}/var/log/onlyoffice/documentserver/spellchecker"
mkdir -p "%{buildroot}/var/log/onlyoffice/documentserver/metrics"
mkdir -p "%{buildroot}/var/log/onlyoffice/documentserver/gc"

#make cache dir
mkdir -p "%{buildroot}/var/lib/onlyoffice/documentserver/App_Data/cache/files"
mkdir -p "%{buildroot}/var/lib/onlyoffice/documentserver/App_Data/docbuilder"

#make exchange dir
mkdir -p "%{buildroot}/var/www/onlyoffice/Data"

#make exchange dir
mkdir -p "%{buildroot}/var/www/onlyoffice/documentserver/fonts"

#install supervisor configs
DS_SUPERVISOR_CONF=%{buildroot}/etc/onlyoffice/documentserver/supervisor/
mkdir -p "$DS_SUPERVISOR_CONF"
cp %{_builddir}/../../../common/documentserver/supervisor/* "$DS_SUPERVISOR_CONF"

# rename extention for supervisor config files
rename 's/.conf$/.ini/' "$DS_SUPERVISOR_CONF"*

#install nginx config
DS_NGINX_CONF=%{buildroot}/etc/onlyoffice/documentserver/nginx/
mkdir -p "$DS_NGINX_CONF"

cp -r %{_builddir}/../../../common/documentserver/nginx/* "$DS_NGINX_CONF"

mkdir -p "%{buildroot}/var/cache/nginx/onlyoffice/documentserver/"

mkdir -p "%{buildroot}/etc/nginx/includes/"
mkdir -p "%{buildroot}/etc/nginx/%{nginx_conf_d}/"

#install logrotate config
DS_LOGROTATE_CONF=%{buildroot}/etc/onlyoffice/documentserver/logrotate/
mkdir -p "$DS_LOGROTATE_CONF"
cp -r %{_builddir}/../../../common/documentserver/logrotate/* "$DS_LOGROTATE_CONF"

%if %{defined example}
#install documentserver example files
mkdir -p "%{buildroot}/var/www/onlyoffice/documentserver-example/"
cp -r $DOCUMENTSERVER_EXAMPLE_HOME/* "%{buildroot}/var/www/onlyoffice/documentserver-example/"

#install dcoumentserver example configs
mkdir -p "%{buildroot}/etc/onlyoffice/documentserver-example/"
cp -r $DOCUMENTSERVER_EXAMPLE_CONFIG/* "%{buildroot}/etc/onlyoffice/documentserver-example/" 

#make log dir
mkdir -p "%{buildroot}/var/log/onlyoffice/documentserver-example"

#install example supervisor configs
DSE_SUPERVISOR_CONF=%{buildroot}/etc/onlyoffice/documentserver-example/supervisor/
mkdir -p "$DSE_SUPERVISOR_CONF"
cp %{_builddir}/../../../common/documentserver-example/supervisor/* "$DSE_SUPERVISOR_CONF"

# rename extention for supervisor config files
rename 's/.conf$/.ini/' "$DSE_SUPERVISOR_CONF"*

#install nginx config
DSE_NGINX_CONF=%{buildroot}/etc/onlyoffice/documentserver-example/nginx/
mkdir -p "$DSE_NGINX_CONF"
cp -r %{_builddir}/../../../common/documentserver-example/nginx/includes "$DSE_NGINX_CONF"
%endif

# Make symlinks for nginx configs
find \
  %{buildroot}/etc/onlyoffice/documentserver*/nginx/includes \
  -name *.conf \
  -exec sh -c '%__ln_s {} %{buildroot}/etc/nginx/includes/$(basename {})' \;

%__ln_s \
  %{buildroot}/etc/onlyoffice/documentserver/nginx/onlyoffice-documentserver.conf \
  %{buildroot}/etc/nginx/%{nginx_conf_d}/onlyoffice-documentserver.conf

mkdir -p "%{buildroot}/etc/supervisord.d/"

# Make symlinks for supervisor configs
find \
  %{buildroot}/etc/onlyoffice/documentserver*/supervisor/ \
  -name *.ini \
  -exec sh -c '%__ln_s {} %{buildroot}/etc/supervisord.d/$(basename {})' \;

mkdir -p "%{buildroot}/etc/logrotate/conf.d/"

# Make symlinks for logrotate configs
find \
  %{buildroot}/etc/onlyoffice/documentserver/logrotate/ \
  -name *.conf \
  -exec sh -c '%__ln_s {} %{buildroot}/etc/logrotate/conf.d/$(basename {})' \;

# Convert absolute links to relative links
symlinks -c \
  %{buildroot}/etc/nginx/%{nginx_conf_d} \
  %{buildroot}/etc/nginx/includes \
  %{buildroot}/etc/supervisord.d \
  %{buildroot}/etc/logrotate/conf.d 

%clean
rm -rf "%{buildroot}"

%files
%attr(-, onlyoffice, onlyoffice) /var/www/onlyoffice/documentserver*/*
%config %attr(440, onlyoffice, onlyoffice) /etc/onlyoffice/documentserver*/*.json
%config %attr(440, onlyoffice, onlyoffice) /etc/onlyoffice/documentserver*/log4js/*.json

%config %attr(-, onlyoffice, onlyoffice) /etc/onlyoffice/documentserver*/nginx/includes/*
%config %attr(-, onlyoffice, onlyoffice) /etc/onlyoffice/documentserver/nginx/*.template

%config(noreplace) /etc/onlyoffice/documentserver/nginx/onlyoffice-documentserver.conf

%config %attr(-, onlyoffice, onlyoffice) /etc/onlyoffice/documentserver/logrotate/*
%config %attr(-, onlyoffice, onlyoffice) /etc/onlyoffice/documentserver*/supervisor*/*

%attr(-, root, root) /usr/lib64/*.so*
%attr(-, root, root) /usr/bin/documentserver-*.sh
%attr(-, root, root) /etc/logrotate/conf.d/*
%attr(-, root, root) /etc/nginx/*
%attr(-, root, root) /etc/supervisord.d/*

%dir
%attr(-, %{nginx_user}, %{nginx_user}) /var/cache/nginx/onlyoffice/documentserver
%attr(755, onlyoffice, onlyoffice) /var/log/onlyoffice

%attr(-, onlyoffice, onlyoffice) /var/lib/onlyoffice
%attr(-, onlyoffice, onlyoffice) /var/www/onlyoffice/Data

%if %{defined example}
%attr(-, onlyoffice, onlyoffice) /var/log/onlyoffice/documentserver-example
%endif

%pre
case "$1" in
  1)
    # Initial installation
    # add group and user for onlyoffice app
    getent group onlyoffice >/dev/null || groupadd -r onlyoffice
    getent passwd onlyoffice >/dev/null || useradd -r -g onlyoffice -d /var/www/onlyoffice/ -s /sbin/nologin onlyoffice
    # add nginx user to onlyoffice group to allow access nginx to onlyoffice log dir
    usermod -a -G onlyoffice %{nginx_user}
  ;;
  2)
    # Upgrade
    # disconnect all users and stop running services
    documentserver-prepare4shutdown.sh
    echo "Stoping documentserver services..."
    supervisorctl stop onlyoffice-documentserver:*
  ;;
esac
exit 0

%post
# Make symlink to libcurl-gnutls
ln -sf /usr/lib64/libcurl.so.4 /usr/lib64/libcurl-gnutls.so.4

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
%{service} supervisord restart >/dev/null 2>&1
%{service} nginx reload >/dev/null 2>&1

%preun
case "$1" in
  0)
    # Uninstall
    # disconnect all users and stop running services
    documentserver-prepare4shutdown.sh
    supervisorctl stop onlyoffice-documentserver:*
  ;;
  1)
    # Upgrade
    :
  ;;
esac

%postun
DIR="/var/www/onlyoffice/documentserver"

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

    supervisorctl update >/dev/null 2>&1
    %{service} nginx reload >/dev/null 2>&1
  ;;
  1)
    # Upgrade
    :
  ;;
esac

%changelog
* Tue Apr 28 2015 ONLYOFFICE (Online documents editor) <support@onlyoffice.com>
- Initial release.
  
- Free version based on open source code licensed under AGPLv3.
  
- Fixed OnlineEditorsExample page work with HTTPS protocol.
  
- Changed the package dependencies.
  
- Updated OnlineEditorsExample module.
  
- Added the 'X-Forwarded-Host' and 'X-Forwarded-Proto' request headers 
    handler.

- Changed use tcp-sockets to unix-sockets.
  
- Changed mono-runtime version in dependencies.
  
- Nodejs back-end.
