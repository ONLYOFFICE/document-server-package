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

DOCUMENTSERVER_BIN=../../../common/documentserver/bin
DOCUMENTSERVER_HOME=../../../common/documentserver/home
DOCUMENTSERVER_CONFIG=../../../common/documentserver/config

DOCUMENTSERVER_EXAMPLE_HOME=../../../common/documentserver-example/home
DOCUMENTSERVER_EXAMPLE_CONFIG=../../../common/documentserver-example/config

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
cp -r ../../bin/*.sh "%{buildroot}/usr/bin/"

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

#install supervisor configs
DS_SUPERVISOR_CONF=%{buildroot}/etc/onlyoffice/documentserver/supervisor/
mkdir -p "$DS_SUPERVISOR_CONF"
cp ../../../common/documentserver/supervisor/* "$DS_SUPERVISOR_CONF"

# rename extention for supervisor config files
rename 's/.conf$/.ini/' "$DS_SUPERVISOR_CONF"*

#install nginx config
DS_NGINX_CONF=%{buildroot}/etc/onlyoffice/documentserver/nginx/
mkdir -p "$DS_NGINX_CONF"
cp ../../../common/documentserver/nginx/onlyoffice-documentserver*.template "$DS_NGINX_CONF"

cp -r ../../../common/documentserver/nginx/includes "$DS_NGINX_CONF"

mkdir -p "%{buildroot}/var/cache/nginx/onlyoffice/documentserver/"

mkdir -p "%{buildroot}/etc/nginx/includes/"

#install fonts
mkdir -p "%{buildroot}/usr/share/fonts/truetype/"
cp -r ../../../common/fonts/* "%{buildroot}/usr/share/fonts/truetype/"

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
cp ../../../common/documentserver-example/supervisor/* "$DSE_SUPERVISOR_CONF"

# rename extention for supervisor config files
rename 's/.conf$/.ini/' "$DSE_SUPERVISOR_CONF"*

#install nginx config
DSE_NGINX_CONF=%{buildroot}/etc/onlyoffice/documentserver-example/nginx/
mkdir -p "$DSE_NGINX_CONF"
cp -r ../../../common/documentserver-example/nginx/includes "$DSE_NGINX_CONF"
%endif

%clean
rm -rf "%{buildroot}"

%files
%attr(-, onlyoffice, onlyoffice) /var/www/onlyoffice/documentserver/*
%config %attr(755, onlyoffice, onlyoffice) /etc/onlyoffice/documentserver/*
%attr(-, root, root) /usr/share/fonts/truetype/*
%attr(-, root, root) /usr/lib64/*.so*
%attr(-, root, root) /usr/bin/documentserver-*.sh

%if %{defined example}
%attr(-, onlyoffice, onlyoffice) /var/www/onlyoffice/documentserver-example/*
%config %attr(755, onlyoffice, onlyoffice) /etc/onlyoffice/documentserver-example/*
%endif

%dir
%attr(-, %{nginx_user}, %{nginx_user}) /var/cache/nginx/onlyoffice/documentserver
%attr(-, root, root) /etc/nginx/includes
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

# Make symlinks for nginx configs
find \
  /etc/onlyoffice/documentserver*/nginx/ \
  -name *.conf \
  -exec sh -c 'ln -sf {} /etc/nginx/includes/$(basename {})' \;

ln \
  -sf \
  /etc/onlyoffice/documentserver/nginx/onlyoffice-documentserver.conf.template \
  /etc/nginx/conf.d/onlyoffice-documentserver.conf

# Make symlinks for supervisor configs
find \
  /etc/onlyoffice/documentserver/supervisor/ \
  -name *.ini \
  -exec sh -c 'ln -sf {} /etc/supervisord.d/$(basename {})' \;

# Make symlink for example supervisor config
find \
  /etc/onlyoffice/documentserver-example/supervisor/ \
  -name *.ini \
  -exec sh -c 'ln -sf {} /etc/supervisord.d/$(basename {})' \;

# generate allfonts.js and thumbnail
documentserver-generate-allfonts.sh true

# check whethere enabled
GET_ENFORCE=$(%{getenforce})
PORTS=()
case ${GET_ENFORCE,,} in
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
    find /etc/supervisord.d/ -name onlyoffice-documentserver*.ini \
      -exec unlink {} \;
    unlink /etc/nginx/conf.d/onlyoffice-documentserver.conf
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
    rm -f $DIR/server/FileConverter/bin/font_selection.bin

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
