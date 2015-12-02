Summary: Online viewers and editors for text, spreadsheet and presentation files
Name: onlyoffice-documentserver-enterprise
Version: {{BUILD_VERSION}}
Release: {{BUILD_NUMBER}}
License: Commercial
Group: Applications/Internet
URL: http://onlyoffice.com/
Vendor: ONLYOFFICE (Online documents editor)
Packager: ONLYOFFICE (Online documents editor) <support@onlyoffice.com>
Requires: mono >= 3.2.0, xsp, mono-locale-extras, nginx >= 1.3.13, mysql-server, wget, supervisor >= 3.0b2, redis, rabbitmq-server, nodejs >= 0.11, nodejs <= 0.12.8, libstdc++ >= 4.9.0, libcurl, libxml2, boost-regex, zlib, gtkglext-libs, xorg-x11-server-Xvfb, libXtst, GConf2, alsa-lib, liberation-fonts-common, dejavu-fonts-common, google-crosextra-carlito-fonts, libreoffice-opensymbol-fonts
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
cp -r ../../Files/documentserver/* "$RPM_BUILD_ROOT/var/www/onlyoffice/documentserver/"
cp -r ../../Files/onlyoffice/* "$RPM_BUILD_ROOT/var/www/onlyoffice/documentserver/"

mkdir -p "$RPM_BUILD_ROOT/var/log/onlyoffice/documentserver/"

#install configs
mkdir -p "$RPM_BUILD_ROOT/etc/onlyoffice/documentserver/"
cp ../../Files/configs/* "$RPM_BUILD_ROOT/etc/onlyoffice/documentserver/"

#install nginx config
mkdir -p "$RPM_BUILD_ROOT/etc/nginx/conf.d/"
cp ../../Files/nginx/onlyoffice-documentserver.conf "$RPM_BUILD_ROOT/etc/nginx/conf.d/"

# OLD_IFS="$IFS"
# IFS="
# "

# for FILE in `find "$RPM_BUILD_ROOT/var/www/onlyoffice/documentserver/"`; do
	# RELFILE="`echo "$FILE" | sed s?"$RPM_BUILD_ROOT"??`"
	# if [ -d "$FILE" ]; then
		# echo "%%attr(-, onlyoffice, onlyoffice) %%dir \"$RELFILE\"" >>documentserver.list
	# else
		# case "$FILE" in
# #			*/WebStudio?\(2\)/web.connections.config )
# #				echo "%%attr(-, onlyoffice, onlyoffice) %%config(noreplace) \"$RELFILE\"" >>documentserver.list
# #			;;

# #			*/WebStudio?\(2\)/[Ww]eb*.config | */TeamLabSvc.exe.Config | */ASC.Mail.Aggregator.CollectionService.exe.config | */ASC.Mail.Watchdog.Service.exe.config )
# #				echo "%%attr(-, onlyoffice, onlyoffice) %%config \"$RELFILE\"" >>documentserver.list
# #			;;

			# * )
				# echo "%%attr(-, onlyoffice, onlyoffice) \"$RELFILE\"" >>documentserver.list
			# ;;
		# esac
	# fi
# done
# IFS="$OLD_IFS"

%clean
rm -rf "$RPM_BUILD_ROOT"

%files
%attr(-, onlyoffice, onlyoffice) /var/www/onlyoffice/documentserver/*
%attr(-, onlyoffice, onlyoffice) /var/log/onlyoffice/
%config %attr(-, onlyoffice, onlyoffice) /etc/onlyoffice/documentserver/*
%config %attr(-, root, root) /etc/nginx/conf.d/onlyoffice-documentserver.conf

%pre
#add group and user for onlyoffice app
getent group onlyoffice >/dev/null || groupadd -r onlyoffice
getent passwd onlyoffice >/dev/null || useradd -r -g onlyoffice -d /var/www/onlyoffice/ -s /sbin/nologin onlyoffice
exit 0

%post
DIR="/var/www/onlyoffice"
LOG_DIR="/var/log/onlyoffice"
APP_DIR="/var/lib/onlyoffice"

# modify permissions for onlyoffice files and folders
mkdir -p "$LOG_DIR/documentserver/DocService"
mkdir -p "$LOG_DIR/documentserver/ExampleService"
mkdir -p "$LOG_DIR/documentserver/FileConverterService"
mkdir -p "$LOG_DIR/documentserver/SpellCheckerService"

mkdir -p "$APP_DIR/documentserver/App_Data"
mkdir -p "$APP_DIR/documentserver/App_Data/cache/files"
mkdir -p "$DIR/Data"
chown onlyoffice:onlyoffice -R "$DIR"

ln -s /var/www/onlyoffice/documentserver/NodeJsProjects/FileConverter/Bin/libDjVuFile.so /usr/lib64/libDjVuFile.so
ln -s /var/www/onlyoffice/documentserver/NodeJsProjects/FileConverter/Bin/libdoctrenderer.so /usr/lib64/libdoctrenderer.so
ln -s /var/www/onlyoffice/documentserver/NodeJsProjects/FileConverter/Bin/libHtmlFile.so /usr/lib64/libHtmlFile.so
ln -s /var/www/onlyoffice/documentserver/NodeJsProjects/FileConverter/Bin/libHtmlRenderer.so /usr/lib64/libHtmlRenderer.so
ln -s /var/www/onlyoffice/documentserver/NodeJsProjects/FileConverter/Bin/libPdfReader.so /usr/lib64/libPdfReader.so
ln -s /var/www/onlyoffice/documentserver/NodeJsProjects/FileConverter/Bin/libPdfWriter.so /usr/lib64/libPdfWriter.so
ln -s /var/www/onlyoffice/documentserver/NodeJsProjects/FileConverter/Bin/libXpsFile.so /usr/lib64/libXpsFile.so
ln -s /var/www/onlyoffice/documentserver/NodeJsProjects/FileConverter/Bin/libUnicodeConverter.so /usr/lib64/libUnicodeConverter.so
ln -s /var/www/onlyoffice/documentserver/NodeJsProjects/FileConverter/Bin/libicudata.so.55 /usr/lib64/libicudata.so.55
ln -s /var/www/onlyoffice/documentserver/NodeJsProjects/FileConverter/Bin/libicuuc.so.55 /usr/lib64/libicuuc.so.55
ln -s /etc/onlyoffice/documentserver/DocService.conf /etc/supervisord.d/DocService.ini
ln -s /etc/onlyoffice/documentserver/ExampleService.conf /etc/supervisord.d/ExampleService.ini
ln -s /etc/onlyoffice/documentserver/FileConverterService.conf /etc/supervisord.d/FileConverterService.ini
ln -s /etc/onlyoffice/documentserver/SpellCheckerService.conf /etc/supervisord.d/SpellCheckerService.ini

# generate allfonts.js and thumbnail
"$DIR/documentserver/Tools/AllFontsGen" "/usr/share/fonts" "$DIR/documentserver/OfficeWeb/sdk/Common/AllFonts.js" "$DIR/documentserver/OfficeWeb/sdk/Common/Images" "$DIR/documentserver/NodeJsProjects/FileConverter/Bin/font_selection.bin"

chown onlyoffice:onlyoffice -R "$LOG_DIR"
chown onlyoffice:onlyoffice -R "$APP_DIR"

# import common ssl certificates
mozroots --import --sync --machine --quiet

mkdir -p /etc/mono/registry/LocalMachine
mkdir -p /usr/share/.mono/keypairs

# configure ngninx for onlyoffice
#rm -f /etc/nginx/sites-enabled/default

# restart dependent services
service supervisord restart >/dev/null 2>&1
service nginx reload >/dev/null 2>&1

%preun
supervisorctl stop all

%postun
DIR="/var/www/onlyoffice"

unlink /usr/lib64/libDjVuFile.so
unlink /usr/lib64/libdoctrenderer.so
unlink /usr/lib64/libHtmlFile.so
unlink /usr/lib64/libHtmlRenderer.so
unlink /usr/lib64/libPdfReader.so
unlink /usr/lib64/libPdfWriter.so
unlink /usr/lib64/libXpsFile.so
unlink /usr/lib64/libUnicodeConverter.so
unlink /usr/lib64/libicudata.so.55
unlink /usr/lib64/libicuuc.so.55

unlink /etc/supervisord.d/DocService.ini
unlink /etc/supervisord.d/ExampleService.ini
unlink /etc/supervisord.d/FileConverterService.ini
unlink /etc/supervisord.d/SpellCheckerService.ini

rm -r $DIR/documentserver/OfficeWeb/sdk/Common/AllFonts.js
rm -r $DIR/documentserver/OfficeWeb/sdk/Common/Images/fonts_thumbnail*
rm -r $DIR/documentserver/NodeJsProjects/FileConverter/Bin/font_selection.bin

service supervisord restart >/dev/null 2>&1
service nginx reload >/dev/null 2>&1

%changelog
* Mon Aug 10 2015 ONLYOFFICE (Online documents editor) <support@onlyoffice.com>
- We have updated ONLYOFFICE Community Server to ver. 8.6.2.
