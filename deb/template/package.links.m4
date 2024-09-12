etc/M4_DS_PREFIX/logrotate/ds.conf etc/logrotate.d/ds.conf

etc/M4_DS_PREFIX/nginx/includes/ds-common.conf etc/nginx/includes/ds-common.conf
etc/M4_DS_PREFIX/nginx/includes/ds-docservice.conf etc/nginx/includes/ds-docservice.conf
etc/M4_DS_PREFIX/nginx/includes/ds-letsencrypt.conf etc/nginx/includes/ds-letsencrypt.conf
etc/M4_DS_PREFIX/nginx/includes/http-common.conf etc/nginx/includes/http-common.conf
etc/M4_DS_PREFIX/nginx/includes/ds-mime.types.conf etc/nginx/includes/ds-mime.types.conf

var/www/M4_DS_PREFIX/server/FileConverter/bin/libDjVuFile.so lib/libDjVuFile.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libdoctrenderer.so lib/libdoctrenderer.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libDocxRenderer.so lib/libDocxRenderer.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libEpubFile.so lib/libEpubFile.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libFb2File.so lib/libFb2File.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libgraphics.so lib/libgraphics.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libHtmlFile2.so lib/libHtmlFile2.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libHtmlRenderer.so lib/libHtmlRenderer.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libkernel.so lib/libkernel.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libkernel_network.so lib/libkernel_network.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libPdfFile.so lib/libPdfFile.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libXpsFile.so lib/libXpsFile.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libUnicodeConverter.so lib/libUnicodeConverter.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libicudata.so.58 lib/libicudata.so.58
var/www/M4_DS_PREFIX/server/FileConverter/bin/libicuuc.so.58 lib/libicuuc.so.58

ifelse('M4_DS_EXAMPLE_ENABLE','1',
etc/M4_DS_PREFIX-example/nginx/includes/ds-example.conf etc/nginx/includes/ds-example.conf,)
