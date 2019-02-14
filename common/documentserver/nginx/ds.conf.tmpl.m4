include M4_NGINX_CONF/http-common.conf;
server {
  listen 0.0.0.0:80;
  listen [::]:80 default_server;
  server_tokens off;
  
  include M4_NGINX_CONF/ds-*.conf;
}