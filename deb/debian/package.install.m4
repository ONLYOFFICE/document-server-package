../common/documentserver/bin/*.sh usr/bin/
../common/documentserver/config/* etc/onlyoffice/documentserver/
../common/documentserver/home/* var/www/onlyoffice/documentserver/
../common/documentserver/nginx/* etc/onlyoffice/documentserver/nginx/

ifelse('DS_EXAMPLE', '1',
../common/documentserver-example/supervisor/* etc/onlyoffice/documentserver-example/supervisor/,
../common/documentserver/supervisor/* etc/onlyoffice/documentserver/supervisor/)

../common/documentserver/logrotate/* etc/onlyoffice/documentserver/logrotate/

ifelse('DS_EXAMPLE', '1',
../common/documentserver-example/config/* etc/onlyoffice/documentserver-example/
../common/documentserver-example/home/* var/www/onlyoffice/documentserver-example/
../common/documentserver-example/nginx/includes/* etc/onlyoffice/documentserver-example/nginx/includes/,)