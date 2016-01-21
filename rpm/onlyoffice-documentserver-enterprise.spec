Summary: Online viewers and editors for text, spreadsheet and presentation files
Name: onlyoffice-documentserver-enterprise
Version: {{PRODUCT_VERSION}}
Release: {{BUILD_NUMBER}}
License: Commercial
Group: Applications/Internet
URL: http://onlyoffice.com/
Vendor: ONLYOFFICE (Online documents editor)
Packager: ONLYOFFICE (Online documents editor) <support@onlyoffice.com>
Requires: nginx >= 1.3.13, mysql, wget, librabbitmq-tools, supervisor >= 3.0b2, nodejs >= 4.2.0, libstdc++ >= 4.9.0, libcurl, libxml2, boost-regex, zlib, gtkglext-libs, xorg-x11-server-Xvfb, libXtst, GConf2, alsa-lib, liberation-mono-fonts, liberation-narrow-fonts, liberation-sans-fonts, liberation-serif-fonts, dejavu-lgc-sans-fonts, dejavu-lgc-sans-mono-fonts, dejavu-lgc-serif-fonts, dejavu-sans-fonts, dejavu-sans-mono-fonts, dejavu-serif-fonts, google-crosextra-carlito-fonts, libreoffice-opensymbol-fonts
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

#install documentserver files
mkdir -p "$RPM_BUILD_ROOT/var/www/onlyoffice/documentserver/"
cp -r ../../../common/documentserver/* "$RPM_BUILD_ROOT/var/www/onlyoffice/documentserver/"
cp -r ../../Files/onlyoffice/* "$RPM_BUILD_ROOT/var/www/onlyoffice/documentserver/"

#install documentserver libs
mkdir -p "$RPM_BUILD_ROOT/usr/lib64/"
cp -r ../../../common/documentserver/NodeJsProjects/FileConverter/Bin/*.so* "$RPM_BUILD_ROOT/usr/lib64/" 
rm "$RPM_BUILD_ROOT"/var/www/onlyoffice/documentserver/NodeJsProjects/FileConverter/Bin/*.so*

#install configs
mkdir -p "$RPM_BUILD_ROOT/etc/onlyoffice/documentserver/"
cp -r ../../../common/config/* "$RPM_BUILD_ROOT/etc/onlyoffice/documentserver/" 
rm -rf "$RPM_BUILD_ROOT/var/www/onlyoffice/documentserver/NodeJsProjects/Common/config/"

#make log dir
mkdir -p "$RPM_BUILD_ROOT/var/log/onlyoffice/documentserver/docservice"
mkdir -p "$RPM_BUILD_ROOT/var/log/onlyoffice/documentserver/example"
mkdir -p "$RPM_BUILD_ROOT/var/log/onlyoffice/documentserver/converter"
mkdir -p "$RPM_BUILD_ROOT/var/log/onlyoffice/documentserver/spellchecker"
mkdir -p "$RPM_BUILD_ROOT/var/log/onlyoffice/documentserver/metrics"

#make cache dir
mkdir -p "$RPM_BUILD_ROOT/var/lib/onlyoffice/documentserver/App_Data/cache/files"

#make exchange dir
mkdir -p "$RPM_BUILD_ROOT/var/www/onlyoffice/Data"

#install supervisor configs
mkdir -p "$RPM_BUILD_ROOT/etc/supervisord.d/"
cp ../../../common/supervisor/* "$RPM_BUILD_ROOT/etc/supervisord.d/"
for f in "$RPM_BUILD_ROOT"/etc/supervisord.d/*.conf; 
do
  mv "$f" "${f%.*}".ini;
done

#install nginx config
mkdir -p "$RPM_BUILD_ROOT/etc/nginx/conf.d/"
cp ../../../common/nginx/onlyoffice-documentserver.conf "$RPM_BUILD_ROOT/etc/nginx/conf.d/"

mkdir -p "$RPM_BUILD_ROOT/etc/nginx/includes/"
cp ../../../common/nginx/includes/* "$RPM_BUILD_ROOT/etc/nginx/includes/"

mkdir -p "$RPM_BUILD_ROOT/var/cache/nginx/onlyoffice/documentserver/"

#install fonts
mkdir -p "$RPM_BUILD_ROOT/usr/share/fonts/truetype/onlyoffice/documentserver/"
cp -r ../../../common/fonts/* "$RPM_BUILD_ROOT/usr/share/fonts/truetype/onlyoffice/documentserver/"

%clean
rm -rf "$RPM_BUILD_ROOT"

%files
%attr(-, onlyoffice, onlyoffice) /var/www/onlyoffice/*
%config %attr(-, onlyoffice, onlyoffice) /etc/onlyoffice/documentserver/*
%config %attr(-, root, root) /etc/nginx/conf.d/onlyoffice-documentserver.conf
%config %attr(-, root, root) /etc/nginx/includes/onlyoffice-*.conf
%config %attr(-, root, root) /etc/supervisord.d/onlyoffice-documentserver*.ini
%attr(-, onlyoffice, onlyoffice) /usr/share/fonts/truetype/onlyoffice/*
%attr(-, root, root) /usr/lib64/*.so*

%dir
%attr(-, nginx, nginx) /var/cache/nginx/onlyoffice/documentserver
%attr(-, onlyoffice, onlyoffice) /var/log/onlyoffice
%attr(-, onlyoffice, onlyoffice) /var/log/onlyoffice/documentserver/*
%attr(-, onlyoffice, onlyoffice) /var/lib/onlyoffice
%attr(-, onlyoffice, onlyoffice) /var/lib/onlyoffice/documentserver/App_Data/cache/files
%attr(-, onlyoffice, onlyoffice) /var/www/onlyoffice/Data

%pre
#add group and user for onlyoffice app
getent group onlyoffice >/dev/null || groupadd -r onlyoffice
getent passwd onlyoffice >/dev/null || useradd -r -g onlyoffice -d /var/www/onlyoffice/ -s /sbin/nologin onlyoffice
exit 0

%post
DIR="/var/www/onlyoffice/documentserver"

# generate allfonts.js and thumbnail
"$DIR/Tools/AllFontsGen" "/usr/share/fonts" "$DIR/OfficeWeb/sdk/Common/AllFonts.js" "$DIR/OfficeWeb/sdk/Common/Images" "$DIR/NodeJsProjects/FileConverter/Bin/font_selection.bin"

# restart dependent services
service supervisord restart >/dev/null 2>&1
service nginx reload >/dev/null 2>&1

%preun
# uninstall action
if [ $1 -eq 0 ]; then
  supervisorctl stop onlyoffice-documentserver:*
fi

%postun
DIR="/var/www/onlyoffice/documentserver"
# uninstall action
if [ $1 -eq 0 ]; then
  rm -f $DIR/OfficeWeb/sdk/Common/AllFonts.js
  rm -f $DIR/OfficeWeb/sdk/Common/Images/fonts_thumbnail*
  rm -f $DIR/NodeJsProjects/FileConverter/Bin/font_selection.bin

  supervisorctl update >/dev/null 2>&1
  service nginx reload >/dev/null 2>&1
fi

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
