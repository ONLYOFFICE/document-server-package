#!/bin/sh

DIR="/var/www/onlyoffice/documentserver"

#Start generate AllFonts.js, font thumbnails and font_selection.bin
sudo -u onlyoffice "$DIR/Tools/AllFontsGen"\
 "/usr/share/fonts"\
 "$DIR/OfficeWeb/sdk/Common/AllFonts.js"\
 "$DIR/OfficeWeb/sdk/Common/Images"\
 "$DIR/NodeJsProjects/FileConverter/Bin/font_selection.bin"

#Restart web-site and converter
sudo supervisorctl restart DocService
sudo supervisorctl restart FileConverterService
