#!/bin/sh

DIR="/var/www/onlyoffice/documentserver"

#Start generate AllFonts.js, font thumbnails and font_selection.bin
sudo -u onlyoffice "$DIR/server/tools/AllFontsGen"\
 "/usr/share/fonts"\
 "$DIR/sdkjs/common/AllFonts.js"\
 "$DIR/sdkjs/common/Images"\
 "$DIR/server/FileConverter/bin/font_selection.bin"

#Restart web-site and converter
sudo supervisorctl restart onlyoffice-documentserver:docservice
sudo supervisorctl restart onlyoffice-documentserver:converter
