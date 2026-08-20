../../common/documentserver/bin/documentserver-example usr/bin
../../common/documentserver/bin/documentserver-flush-cache usr/bin
../../common/documentserver/bin/documentserver-generate-allfonts usr/bin
../../common/documentserver/bin/documentserver-jwt-status usr/bin
../../common/documentserver/bin/documentserver-letsencrypt usr/bin
../../common/documentserver/bin/documentserver-prepare4shutdown usr/bin
../../common/documentserver/bin/documentserver-static-gzip usr/bin
../../common/documentserver/bin/documentserver-update-securelink usr/bin
ifelse('M4_DS_PLUGIN_INSTALLATION','true', ../../common/documentserver/bin/documentserver-pluginsmanager usr/bin,)
ifelse(regexp(M4_PACKAGE_NAME,`documentserver$'),-1, ../../common/documentserver/bin/documentserver-admin usr/bin,)
../../common/documentserver/config/* etc/M4_DS_PREFIX
../../common/documentserver/home/* var/www/M4_DS_PREFIX
../../common/documentserver/nginx/*.tmpl etc/M4_DS_PREFIX/nginx
../../common/documentserver/nginx/includes/*.conf etc/M4_DS_PREFIX/nginx/includes

../../common/documentserver/systemd/ds-docservice.service /usr/lib/systemd/system
../../common/documentserver/systemd/ds-converter.service /usr/lib/systemd/system
../../common/documentserver/systemd/ds-metrics.service /usr/lib/systemd/system
ifelse(regexp(M4_PACKAGE_NAME,`documentserver$'),-1,
../../common/documentserver/systemd/ds-adminpanel.service /usr/lib/systemd/system,)

../../common/documentserver/sudoers/documentserver /etc/sudoers.d

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
../../common/documentserver-example/systemd/*.service /usr/lib/systemd/system,)

../../common/documentserver/logrotate/*.conf etc/M4_DS_PREFIX/logrotate

../../common/documentserver/fontconfig/09-documentserver-fonts.conf etc/fonts/conf.d

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
../../common/documentserver-example/config/* etc/M4_DS_PREFIX-example
../../common/documentserver-example/home/* var/www/M4_DS_PREFIX-example
../../common/documentserver-example/nginx/includes/*.conf etc/M4_DS_PREFIX-example/nginx/includes,)