#!/bin/sh

ONLYOFFICE_DATA_CONTAINER=false
if [ "$1" != "" ]; then
    ONLYOFFICE_DATA_CONTAINER=$1
fi

DIR="/var/www/M4_DS_PREFIX"

#Start generate AllFonts.js, font thumbnails and font_selection.bin
echo -n Generating AllFonts.js, please wait...


sudo -u ds "$DIR/server/tools/AllFontsGen"\
  --input="$DIR/core-fonts"\
  --allfonts-web="$DIR/sdkjs/common/AllFonts.js"\
  --allfonts="$DIR/server/FileConverter/bin/AllFonts.js"\
  --images="$DIR/sdkjs/common/Images"\
  --selection="$DIR/server/FileConverter/bin/font_selection.bin"\
  --output-web="$DIR/fonts"\
  --use-system="true"

echo Done

#Remove gzipped fonts
rm -f $DIR/fonts/*.gz $DIR/sdkjs/common/AllFonts.js.gz

#Restart web-site and converter
if [ "$ONLYOFFICE_DATA_CONTAINER" != "true" ]; then
 sudo supervisorctl restart ds:docservice
 sudo supervisorctl restart ds:converter
fi
