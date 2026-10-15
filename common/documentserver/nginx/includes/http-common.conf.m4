upstream docservice {
  server localhost:8000 max_fails=0 fail_timeout=0s;
}

upstream adminpanel {  
  server localhost:9000 max_fails=0 fail_timeout=0s;
}

upstream example {  
  server localhost:3000;
}

# Skip successful static and healthcheck reads
map "$request_method:$status:$uri" $ds_access_loggable {
  ~^(GET|HEAD):[23][0-9][0-9]:/(?:\Q`'M4_PRODUCT_VERSION\E-[^/]+/)?(?:web-apps|sdkjs|sdkjs-plugins|fonts|dictionaries|welcome)(?:/|$) 0;
  ~^(GET|HEAD):[23][0-9][0-9]:/(?:\Q`'M4_PRODUCT_VERSION\E-[^/]+/)?(?:document_editor_service_worker\.js|meta/formats|healthcheck/?)$ 0;
  default 1;
}

log_format ds_access escape=json
  '{"timestamp":"$time_iso8601",'
  '"client_ip":"$remote_addr",'
  '"method":"$request_method",'
  '"uri":"$uri",'
  '"status":$status,'
  '"bytes_sent":$bytes_sent,'
  '"request_time":$request_time,'
  '"upstream_status":"$upstream_status",'
  '"upstream_response_time":"$upstream_response_time"}';

map $http_host $this_host {
    "" $host;
    default $http_host;
}

map $http_cloudfront_forwarded_proto:$http_x_forwarded_proto $the_scheme {
     default $scheme;
     "~^https?:.*" $http_cloudfront_forwarded_proto;
     "~^:https?$" $http_x_forwarded_proto;
     "~^:wss$" https;
}

map $http_x_forwarded_host $the_host {
    ~^([^,]+)  $1;
    default $http_x_forwarded_host;
    "" $this_host;
}

map $http_upgrade $proxy_connection {
  websocket upgrade;
  default close;
}

map $http_x_forwarded_prefix $the_prefix {
    default $http_x_forwarded_prefix;
}

# add_header is not inherited by a level that declares its own, so each location repeats these
map $the_scheme $hsts_header {
    https "max-age=31536000";
    default "";
}

# One-time cache reset for clients cached under the old expires 365d; stops once the cookie is set
map $cookie_ds_cache_reset $clear_site_data {
    "1" "";
    default '"cache"';
}

proxy_set_header Host $http_host;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection $proxy_connection;
proxy_set_header X-Forwarded-Host $the_host;
proxy_set_header X-Forwarded-Proto $the_scheme;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
