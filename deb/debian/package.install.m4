../common/documentserver/bin/*.sh usr/bin/
../common/documentserver/config/* etc/M4_DS_PREFIX/
../common/documentserver/home/* var/www/M4_DS_PREFIX/
../common/documentserver/nginx/*.conf etc/M4_DS_PREFIX/nginx/
../common/documentserver/nginx/*.tmpl etc/M4_DS_PREFIX/nginx/
../common/documentserver/nginx/includes/*.conf etc/M4_DS_PREFIX/nginx/includes/

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
../common/documentserver-example/supervisor/* etc/M4_DS_PREFIX-example/supervisor/,
../common/documentserver/supervisor/* etc/M4_DS_PREFIX/supervisor/)

../common/documentserver/logrotate/* etc/M4_DS_PREFIX/logrotate/

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
../common/documentserver-example/config/* etc/M4_DS_PREFIX-example/
../common/documentserver-example/home/* var/www/M4_DS_PREFIX-example/
../common/documentserver-example/nginx/includes/*.conf etc/M4_DS_PREFIX-example/nginx/includes/,)