../common/documentserver/bin/*.sh usr/bin/
../common/documentserver/config/* etc/M4_DS_PREFIX/
../common/documentserver/home/* var/www/M4_DS_PREFIX/
../common/documentserver/nginx/*.conf etc/M4_DS_PREFIX/nginx/
../common/documentserver/nginx/*.tmpl etc/M4_DS_PREFIX/nginx/
../common/documentserver/nginx/includes/*.conf etc/M4_DS_PREFIX/nginx/includes/
../common/documentserver/nginx/includes/ds-mime.types etc/M4_DS_PREFIX/nginx/includes/

../common/documentserver/supervisor/*.conf etc/M4_DS_PREFIX/supervisor/

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
../common/documentserver-example/supervisor/*.conf etc/M4_DS_PREFIX-example/supervisor/,)

../common/documentserver/logrotate/*.conf etc/M4_DS_PREFIX/logrotate/

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
../common/documentserver-example/config/* etc/M4_DS_PREFIX-example/
../common/documentserver-example/home/* var/www/M4_DS_PREFIX-example/
../common/documentserver-example/nginx/includes/*.conf etc/M4_DS_PREFIX-example/nginx/includes/,)