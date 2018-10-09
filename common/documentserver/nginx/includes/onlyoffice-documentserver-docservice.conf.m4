#welcome page
rewrite ^/$ $the_scheme://$the_host/welcome/ redirect;

#support old version
rewrite ^\/OfficeWeb(\/apps\/.*)$ $the_scheme://$the_host/PACKAGE_VERSION/web-apps$1 redirect;

#script caching protection
rewrite ^(\/web-apps\/apps\/(?!api\/).*)$ $the_scheme://$the_host/PACKAGE_VERSION/$1 redirect;

#disable caching for api.js
location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(web-apps\/apps\/api\/documents\/api\.js)$ {
  expires -1;
  # gzip_static on;
  alias  DS_ROOT/$2;
}

#suppress logging the unsupported locale error
location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(web-apps)(\/.*\.json)$ {
  expires 365d;
  error_log DEV_NULL crit;
  # gzip_static on;
  alias DS_ROOT/$2$3;
}

location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(web-apps|sdkjs|sdkjs-plugins|fonts)(\/.*)$ {
  expires 365d;
  # gzip_static on;
  alias DS_ROOT/$2$3;
}

location ~ ^(\/cache\/files.*)(\/.*) {
  alias DS_FILES/App_Data$1;
  add_header Content-Disposition $arg_disposition;

  set $secret_string onlyoffice;
  secure_link $arg_md5,$arg_expires;
  secure_link_md5 "$secure_link_expires$uri$secret_string";

  if ($secure_link = "") {
    return 403;
  }

  if ($secure_link = "0") {
    return 410;
  }
}

# Allow server info only from 127.0.0.1
location /info {
  allow 127.0.0.1;
  deny all;
  proxy_pass http://docservice;
}

location / {
  proxy_pass http://docservice;
}

location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?(\/doc\/.*) {
  proxy_pass http://docservice$2;
  proxy_http_version 1.1;
}

location /PACKAGE_VERSION/ {
  proxy_pass http://docservice/;
}

