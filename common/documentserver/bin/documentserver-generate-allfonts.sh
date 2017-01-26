#!/bin/sh

ONLYOFFICE_DATA_CONTAINER=false
if [ "$1" != "" ]; then
    ONLYOFFICE_DATA_CONTAINER=$1
fi

DIR="/var/www/onlyoffice/documentserver"

#Start generate AllFonts.js, font thumbnails and font_selection.bin
echo -n Generating AllFonts.js, please wait...

sudo -u onlyoffice "$DIR/server/tools/AllFontsGen"\
 "/usr/share/fonts"\
 "$DIR/sdkjs/common/AllFonts.js"\
 "$DIR/sdkjs/common/Images"\
 "$DIR/server/FileConverter/bin/font_selection.bin"
 
echo Done

#Restart web-site and converter
if [ "$ONLYOFFICE_DATA_CONTAINER" != "true" ]; then
 sudo supervisorctl restart onlyoffice-documentserver:docservice
 sudo supervisorctl restart onlyoffice-documentserver:converter
fi
