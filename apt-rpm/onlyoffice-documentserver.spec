Summary: Online viewers and editors for text, spreadsheet and presentation files
Name: %{_package_name}
Version: %{_product_version}
Release: %{_build_number}
License: AGPL
Group: Applications/Internet
URL: http://onlyoffice.com/
Vendor: ONLYOFFICE (Online documents editor)
Packager: ONLYOFFICE (Online documents editor) <support@onlyoffice.com>
Requires: nginx >= 1.3.13, postgresql >= 9.1, wget, librabbitmq-c, supervisor >= 3.0b2, node >= 6.9.1, npm, libstdc++ >= 4.8.4, libcurl, libxml2, libboost_regex1.57.0, zlib, libXScrnSaver, libgtkglext, xorg-xvfb, libXtst, GConf, libalsa, pwgen, fonts-ttf-liberation, fonts-ttf-liberation-narrow, fonts-ttf-dejavu, fonts-ttf-dejavu-lgc, fonts-ttf-google-crosextra-carlito, fonts-ttf-ms
BuildArch: x86_64
AutoReq: no
AutoProv: no

%description
Free open source office suite and business productivity tools in one solution:
online document editors, file and project management, CRM

%prep
rm -rf "$RPM_BUILD_ROOT"

%build

%install

DOCUMENTSERVER_BIN=../../../common/documentserver/bin
DOCUMENTSERVER_HOME=../../../common/documentserver/home
DOCUMENTSERVER_CONFIG=../../../common/documentserver/config

#install documentserver files
mkdir -p "$RPM_BUILD_ROOT/var/www/onlyoffice/documentserver/"
cp -r $DOCUMENTSERVER_HOME/* "$RPM_BUILD_ROOT/var/www/onlyoffice/documentserver/"

#install documentserver libs
mkdir -p "$RPM_BUILD_ROOT/usr/lib64/"
cp -r $DOCUMENTSERVER_HOME/server/FileConverter/bin/*.so* "$RPM_BUILD_ROOT/usr/lib64/" 
rm "$RPM_BUILD_ROOT"/var/www/onlyoffice/documentserver/server/FileConverter/bin/*.so*

#install documentserver bin
mkdir -p "$RPM_BUILD_ROOT/usr/bin/"
cp -r $DOCUMENTSERVER_BIN/*.sh "$RPM_BUILD_ROOT/usr/bin/"
cp -r ../../bin/*.sh "$RPM_BUILD_ROOT/usr/bin/"

#install configs
mkdir -p "$RPM_BUILD_ROOT/etc/onlyoffice/documentserver/"
cp -r $DOCUMENTSERVER_CONFIG/* "$RPM_BUILD_ROOT/etc/onlyoffice/documentserver/" 

#make log dir
mkdir -p "$RPM_BUILD_ROOT/var/log/onlyoffice/documentserver/docservice"
mkdir -p "$RPM_BUILD_ROOT/var/log/onlyoffice/documentserver/converter"
mkdir -p "$RPM_BUILD_ROOT/var/log/onlyoffice/documentserver/spellchecker"
mkdir -p "$RPM_BUILD_ROOT/var/log/onlyoffice/documentserver/metrics"
mkdir -p "$RPM_BUILD_ROOT/var/log/onlyoffice/documentserver/gc"

#make cache dir
mkdir -p "$RPM_BUILD_ROOT/var/lib/onlyoffice/documentserver/App_Data/cache/files"
mkdir -p "$RPM_BUILD_ROOT/var/lib/onlyoffice/documentserver/App_Data/docbuilder"

#make exchange dir
mkdir -p "$RPM_BUILD_ROOT/var/www/onlyoffice/Data"

#install supervisor configs
mkdir -p "$RPM_BUILD_ROOT/etc/supervisord.d/"
cp ../../../common/documentserver/supervisor/* "$RPM_BUILD_ROOT/etc/supervisord.d/"
for f in "$RPM_BUILD_ROOT"/etc/supervisord.d/*.conf; 
do
  mv "$f" "${f%.*}".ini;
done

#install nginx config
mkdir -p "$RPM_BUILD_ROOT/etc/nginx/conf.d/"
cp ../../../common/documentserver/nginx/onlyoffice-documentserver*.template "$RPM_BUILD_ROOT/etc/nginx/conf.d/"

mkdir -p "$RPM_BUILD_ROOT/etc/nginx/includes/"
cp ../../../common/documentserver/nginx/includes/* "$RPM_BUILD_ROOT/etc/nginx/includes/"

mkdir -p "$RPM_BUILD_ROOT/var/cache/nginx/onlyoffice/documentserver/"

#install fonts
mkdir -p "$RPM_BUILD_ROOT/usr/share/fonts/truetype/"
cp -r ../../../common/fonts/* "$RPM_BUILD_ROOT/usr/share/fonts/truetype/"

%clean
rm -rf "$RPM_BUILD_ROOT"

%files
%attr(-, onlyoffice, onlyoffice) /var/www/onlyoffice/*
%config %attr(-, onlyoffice, onlyoffice) /etc/onlyoffice/documentserver/*
%config %attr(-, root, root) /etc/nginx/conf.d/onlyoffice-documentserver*.template
%config %attr(-, root, root) /etc/nginx/includes/onlyoffice-*.conf
%config %attr(-, root, root) /etc/supervisord.d/onlyoffice-documentserver*.ini
%attr(-, root, root) /usr/share/fonts/truetype/*
%attr(-, root, root) /usr/lib64/*.so*
%attr(-, root, root) /usr/bin/documentserver-*.sh

%dir
%attr(-, _nginx, _nginx) /var/cache/nginx/onlyoffice/documentserver
%attr(755, onlyoffice, onlyoffice) /var/log/onlyoffice
%attr(755, onlyoffice, onlyoffice) /var/log/onlyoffice/documentserver/*
%attr(-, onlyoffice, onlyoffice) /var/lib/onlyoffice
%attr(-, onlyoffice, onlyoffice) /var/lib/onlyoffice/documentserver/App_Data/cache/files
%attr(-, onlyoffice, onlyoffice) /var/lib/onlyoffice/documentserver/App_Data/docbuilder
%attr(-, onlyoffice, onlyoffice) /var/www/onlyoffice/Data

%pre
case "$1" in
  1)
    # Initial installation
    # add group and user for onlyoffice app
    getent group onlyoffice >/dev/null || groupadd -r onlyoffice
    getent passwd onlyoffice >/dev/null || useradd -r -g onlyoffice -d /var/www/onlyoffice/ -s /sbin/nologin onlyoffice
    # add _nginx user to onlyoffice group to allow access nginx to onlyoffice log dir
    usermod -a -G onlyoffice _nginx
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

# restart dependent services
/sbin/service supervisord restart >/dev/null 2>&1
/sbin/service nginx reload >/dev/null 2>&1

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
    rm -f $DIR/server/FileConverter/bin/font_selection.bin
    
    rm -f /etc/nginx/conf.d/onlyoffice-documentserver.conf

    supervisorctl update >/dev/null 2>&1
    /sbin/service nginx reload >/dev/null 2>&1
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
