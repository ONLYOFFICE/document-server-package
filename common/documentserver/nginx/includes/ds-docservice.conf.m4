#welcome page
rewrite ^/$ $the_scheme://$the_host/welcome/ redirect;

#support old version
rewrite ^\/OfficeWeb(\/apps\/.*)$ $the_scheme://$the_host/M4_PACKAGE_VERSION/web-apps$1 redirect;

#script caching protection
rewrite ^(\/web-apps\/apps\/(?!api\/).*)$ $the_scheme://$the_host/M4_PACKAGE_VERSION$1 redirect;

#disable caching for api.js
location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(web-apps\/apps\/api\/documents\/api\.js)$ {
  expires -1;
  # gzip_static on;
  alias  M4_DS_ROOT/$2;
}

#suppress logging the unsupported locale error in web-apps
location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(web-apps)(\/.*\.json)$ {
  expires 365d;
  error_log M4_DEV_NULL crit;
  # gzip_static on;
  alias M4_DS_ROOT/$2$3;
}

#suppress logging the unsupported locale error in plugins
location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(sdkjs-plugins)(\/.*\.json)$ {
  expires 365d;
  error_log M4_DEV_NULL crit;
  # gzip_static on;
  alias M4_DS_ROOT/$2$3;
}

location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(web-apps|sdkjs|sdkjs-plugins|fonts)(\/.*)$ {
  expires 365d;
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
 location ~* ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(internal)(\/.*)$ {
  allow 127.0.0.1;
  deny all;
  proxy_pass http://docservice/$2$3;
}

# Allow "/info" interface only from 127.0.0.1 by default
# Comment out lines allow 127.0.0.1; and deny all; 
# of below section to turn on the info page
location ~* ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(info)(\/.*)$ {
  allow 127.0.0.1;
  deny all;
  proxy_pass http://docservice/$2$3;
}

location / {
  proxy_pass http://docservice;
}

location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?(\/doc\/.*) {
  proxy_pass http://docservice$2;
  proxy_http_version 1.1;
}

location /M4_PACKAGE_VERSION/ {
  proxy_pass http://docservice/;
}

location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(dictionaries)(\/.*)$ {
  expires 365d;
  alias M4_DS_ROOT/$2$3;
}

