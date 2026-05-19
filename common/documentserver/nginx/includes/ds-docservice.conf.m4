#welcome page
location = / { return 302 $the_scheme://$the_host$the_prefix/welcome/; }

#script caching protection
location ~ ^(?<cache>\/web-apps\/apps\/(?!api\/documents\/api\.js$).*)$ {
  return 302 $the_scheme://$the_host$the_prefix/M4_PRODUCT_VERSION-$cache_tag$cache$is_args$args;
}

#disable caching for api.js
location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\w]+)?\/(web-apps\/apps\/api\/documents\/api\.js)$ {
  expires off;
  add_header Cache-Control "no-store, no-cache, must-revalidate";
  # gzip_static on;
  alias  M4_DS_ROOT/$2;
}

location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\w]+)?\/(document_editor_service_worker.js)$ {
  add_header Cache-Control "public, max-age=31536000, immutable" always;
  # gzip_static on;
  alias  M4_DS_ROOT/sdkjs/common/serviceworker/$2;
}

#suppress logging the unsupported locale error in web-apps
location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\w]+)?\/(web-apps)(\/.*\.json)$ {
  add_header Cache-Control "public, max-age=31536000, immutable" always;
  error_log M4_DEV_NULL crit;
  # gzip_static on;
  alias M4_DS_ROOT/$2$3;
}

#suppress logging the unsupported locale error in plugins
location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\w]+)?\/(sdkjs-plugins)(\/.*\.json)$ {
  add_header Cache-Control "public, max-age=31536000, immutable" always;
  error_log M4_DEV_NULL crit;
  # gzip_static on;
  alias M4_DS_ROOT/$2$3;
}

location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\w]+)?\/(web-apps|sdkjs|sdkjs-plugins|fonts|dictionaries)(\/.*)$ {
  add_header Cache-Control "public, max-age=31536000, immutable" always;
  # gzip_static on;
  alias M4_DS_ROOT/$2$3;
}

location ~* ^(\/cache\/files.*)(\/.*) {
  alias M4_DS_FILES/App_Data$1;
  add_header Content-Disposition "attachment; filename*=UTF-8''$arg_filename";

  secure_link $arg_md5,$arg_expires;
  secure_link_md5 "$secure_link_expires$uri$secure_link_secret";

  if ($secure_link = "") {
    return 403;
  }

  if ($secure_link = "0") {
    return 410;
  }
}

# Allow "/internal" interface only from 127.0.0.1
# Don't comment out the section below for the security reason!
 location ~* ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\w]+)?\/(internal)(\/.*)$ {
  allow 127.0.0.1;
  deny all;
  proxy_pass http://docservice/$2$3;
}

# Allow "/info" interface only from 127.0.0.1 by default
# Comment out lines allow 127.0.0.1; and deny all; 
# of below section to turn on the info page
location ~* ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\w]+)?\/(info)(\/.*)$ {
  allow 127.0.0.1;
  deny all;
  proxy_pass http://docservice/$2$3;
}

#document formats discovery
location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\w]+)?\/(meta\/formats)$ {
  add_header Cache-Control "public, max-age=31536000, immutable" always;
  default_type application/json;
  # gzip_static on;
  alias M4_DS_ROOT/document-formats/onlyoffice-docs-formats.json;
}

location / {
  proxy_pass http://docservice;
  proxy_http_version 1.1;
  proxy_read_timeout 300s;
  proxy_send_timeout 300s;
  proxy_connect_timeout 300s;
  proxy_buffering on;
  proxy_buffers 64 32k;
  proxy_busy_buffers_size 64k;
  proxy_max_temp_file_size 0;
  proxy_redirect off;
}

location ~* ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\w]+)?\/(ai-proxy)(\/.*)?$ {
  proxy_pass http://docservice/$2$3;

  proxy_connect_timeout 300s;
  proxy_send_timeout    300s;
  proxy_read_timeout    300s;
  send_timeout          300s;
}

location ~ ^/([\d]+\.[\d]+\.[\d]+[\.|-][\w]+)/(?<path>.*)$ {
  proxy_pass http://docservice/$path$is_args$args;
  proxy_http_version 1.1;
}


