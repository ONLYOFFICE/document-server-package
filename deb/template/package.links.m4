# Temporary compatibility aliases for legacy .sh command names
usr/bin/documentserver-example usr/bin/documentserver-example.sh
usr/bin/documentserver-flush-cache usr/bin/documentserver-flush-cache.sh
usr/bin/documentserver-generate-allfonts usr/bin/documentserver-generate-allfonts.sh
usr/bin/documentserver-jwt-status usr/bin/documentserver-jwt-status.sh
usr/bin/documentserver-letsencrypt usr/bin/documentserver-letsencrypt.sh
usr/bin/documentserver-prepare4shutdown usr/bin/documentserver-prepare4shutdown.sh
usr/bin/documentserver-static-gzip usr/bin/documentserver-static-gzip.sh
usr/bin/documentserver-update-securelink usr/bin/documentserver-update-securelink.sh
ifelse('M4_DS_PLUGIN_INSTALLATION','true', usr/bin/documentserver-pluginsmanager usr/bin/documentserver-pluginsmanager.sh,)
ifelse(regexp(M4_PACKAGE_NAME,`documentserver$'),-1, usr/bin/documentserver-admin usr/bin/documentserver-admin.sh,)

etc/M4_DS_PREFIX/logrotate/ds.conf etc/logrotate.d/ds.conf

etc/M4_DS_PREFIX/nginx/includes/ds-common.conf etc/nginx/includes/ds-common.conf
etc/M4_DS_PREFIX/nginx/includes/ds-docservice.conf etc/nginx/includes/ds-docservice.conf
ifelse(regexp(M4_PACKAGE_NAME,`documentserver$'),-1,
etc/M4_DS_PREFIX/nginx/includes/ds-adminpanel.conf etc/nginx/includes/ds-adminpanel.conf,)
etc/M4_DS_PREFIX/nginx/includes/ds-letsencrypt.conf etc/nginx/includes/ds-letsencrypt.conf
etc/M4_DS_PREFIX/nginx/includes/http-common.conf etc/nginx/includes/http-common.conf
etc/M4_DS_PREFIX/nginx/includes/ds-mime.types.conf etc/nginx/includes/ds-mime.types.conf

ifelse('M4_DS_EXAMPLE_ENABLE','1',
etc/M4_DS_PREFIX-example/nginx/includes/ds-example.conf etc/nginx/includes/ds-example.conf,)
