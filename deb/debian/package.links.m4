etc/M4_DS_PREFIX/logrotate/onlyoffice-documentserver.conf etc/logrotate/conf.d/onlyoffice-documentserver.conf

etc/M4_DS_PREFIX/nginx/includes/onlyoffice-documentserver-common.conf etc/nginx/includes/onlyoffice-documentserver-common.conf
etc/M4_DS_PREFIX/nginx/includes/onlyoffice-documentserver-docservice.conf etc/nginx/includes/onlyoffice-documentserver-docservice.conf
etc/M4_DS_PREFIX/nginx/includes/onlyoffice-documentserver-spellchecker.conf etc/nginx/includes/onlyoffice-documentserver-spellchecker.conf
etc/M4_DS_PREFIX/nginx/includes/onlyoffice-http.conf etc/nginx/includes/onlyoffice-http.conf

etc/M4_DS_PREFIX/supervisor/onlyoffice-documentserver-converter.conf etc/supervisor/conf.d/onlyoffice-documentserver-converter.conf
etc/M4_DS_PREFIX/supervisor/onlyoffice-documentserver-docservice.conf etc/supervisor/conf.d/onlyoffice-documentserver-docservice.conf
etc/M4_DS_PREFIX/supervisor/onlyoffice-documentserver-gc.conf etc/supervisor/conf.d/onlyoffice-documentserver-gc.conf
etc/M4_DS_PREFIX/supervisor/onlyoffice-documentserver-metrics.conf etc/supervisor/conf.d/onlyoffice-documentserver-metrics.conf
etc/M4_DS_PREFIX/supervisor/onlyoffice-documentserver-spellchecker.conf etc/supervisor/conf.d/onlyoffice-documentserver-spellchecker.conf
etc/M4_DS_PREFIX/supervisor/onlyoffice-documentserver.conf etc/supervisor/conf.d/onlyoffice-documentserver.conf

etc/M4_DS_PREFIX/logrotate/onlyoffice-documentserver.conf etc/logrotate/conf.d/onlyoffice-documentserver.conf

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

ifelse('DS_EXAMPLE','1',
etc/M4_DS_PREFIX-example/nginx/includes/onlyoffice-documentserver-example.conf etc/nginx/includes/onlyoffice-documentserver-example.conf
etc/M4_DS_PREFIX-example/supervisor/onlyoffice-documentserver-example.conf etc/supervisor/conf.d/onlyoffice-documentserver-example.conf
etc/M4_DS_PREFIX-example/supervisor/onlyoffice-documentserver.conf etc/supervisor/conf.d/onlyoffice-documentserver.conf
,)