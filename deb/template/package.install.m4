../../common/documentserver/bin/*.sh usr/bin
../../common/documentserver/config/* etc/M4_DS_PREFIX
../../common/documentserver/home/* var/www/M4_DS_PREFIX
../../common/documentserver/nginx/*.tmpl etc/M4_DS_PREFIX/nginx
../../common/documentserver/nginx/includes/*.conf etc/M4_DS_PREFIX/nginx/includes

../../common/documentserver/init.d/ds-converter /etc/init.d
../../common/documentserver/init.d/ds-docservice /etc/init.d
../../common/documentserver/init.d/ds-metrics /etc/init.d

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
../../common/documentserver-example/init.d/ds-example /etc/init.d
../../common/documentserver-example/systemd/*.service /lib/systemd/system,)

../../common/documentserver/logrotate/*.conf etc/M4_DS_PREFIX/logrotate

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
../../common/documentserver-example/config/* etc/M4_DS_PREFIX-example
../../common/documentserver-example/home/* var/www/M4_DS_PREFIX-example
../../common/documentserver-example/nginx/includes/*.conf etc/M4_DS_PREFIX-example/nginx/includes,)