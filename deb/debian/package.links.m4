etc/M4_DS_PREFIX/logrotate/ds.conf etc/logrotate.d/ds.conf

etc/M4_DS_PREFIX/nginx/includes/ds-common.conf etc/nginx/includes/ds-common.conf
etc/M4_DS_PREFIX/nginx/includes/ds-docservice.conf etc/nginx/includes/ds-docservice.conf
etc/M4_DS_PREFIX/nginx/includes/ds-letsencrypt.conf etc/nginx/includes/ds-letsencrypt.conf
etc/M4_DS_PREFIX/nginx/includes/http-common.conf etc/nginx/includes/http-common.conf

etc/M4_DS_PREFIX/supervisor/ds-converter.conf etc/supervisor/conf.d/ds-converter.conf
etc/M4_DS_PREFIX/supervisor/ds-docservice.conf etc/supervisor/conf.d/ds-docservice.conf
etc/M4_DS_PREFIX/supervisor/ds-metrics.conf etc/supervisor/conf.d/ds-metrics.conf

var/www/M4_DS_PREFIX/server/FileConverter/bin/libDjVuFile.so lib/libDjVuFile.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libdoctrenderer.so lib/libdoctrenderer.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libgraphics.so lib/libgraphics.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libHtmlFile.so lib/libHtmlFile.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libHtmlRenderer.so lib/libHtmlRenderer.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libkernel.so lib/libkernel.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libPdfReader.so lib/libPdfReader.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libPdfWriter.so lib/libPdfWriter.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libXpsFile.so lib/libXpsFile.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libUnicodeConverter.so lib/libUnicodeConverter.so
var/www/M4_DS_PREFIX/server/FileConverter/bin/libicudata.so.58 lib/libicudata.so.58
var/www/M4_DS_PREFIX/server/FileConverter/bin/libicuuc.so.58 lib/libicuuc.so.58

ifelse('M4_DS_EXAMPLE_ENABLE','1',
etc/M4_DS_PREFIX-example/nginx/includes/ds-example.conf etc/nginx/includes/ds-example.conf
etc/M4_DS_PREFIX-example/supervisor/ds-example.conf etc/supervisor/conf.d/ds-example.conf
etc/M4_DS_PREFIX-example/supervisor/ds.conf etc/supervisor/conf.d/ds.conf
,
etc/M4_DS_PREFIX/supervisor/ds.conf etc/supervisor/conf.d/ds.conf)