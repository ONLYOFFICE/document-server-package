etc/M4_DS_PREFIX/logrotate/ds.conf etc/logrotate.d/ds.conf

etc/M4_DS_PREFIX/nginx/includes/ds-common.conf etc/nginx/includes/ds-common.conf
etc/M4_DS_PREFIX/nginx/includes/ds-docservice.conf etc/nginx/includes/ds-docservice.conf
etc/M4_DS_PREFIX/nginx/includes/ds-letsencrypt.conf etc/nginx/includes/ds-letsencrypt.conf
etc/M4_DS_PREFIX/nginx/includes/http-common.conf etc/nginx/includes/http-common.conf
etc/M4_DS_PREFIX/nginx/includes/ds-mime.types.conf etc/nginx/includes/ds-mime.types.conf

ifelse('M4_DS_EXAMPLE_ENABLE','1',
etc/M4_DS_PREFIX-example/nginx/includes/ds-example.conf etc/nginx/includes/ds-example.conf,)
