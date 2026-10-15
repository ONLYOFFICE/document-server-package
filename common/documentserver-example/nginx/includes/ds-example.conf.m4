#welcome page - html and its assets always revalidate, so an update shows up right away
location = /welcome {
  return 302 $the_scheme://$the_host$the_prefix/welcome/$is_args$args;
}

location ~ ^(\/welcome\/.*)$ {
  add_header Strict-Transport-Security $hsts_header always;
  add_header X-Content-Type-Options nosniff always;
  add_header Cache-Control "no-cache" always;
  #same one-time reset as location = / - covers a bookmarked /welcome/ with stale assets
  add_header Set-Cookie "ds_cache_reset=1; Path=/; Max-Age=31536000; SameSite=Lax" always;
  add_header Clear-Site-Data $clear_site_data always;
  alias M4_DS_EXAMPLE$1;
  index index.html;
}

#versioned welcome urls handed out by earlier builds - back to the canonical path, with or without a trailing slash
location ~ ^\/[\d]+\.[\d]+\.[\d]+[\.|-][\w]+(\/welcome(?:\/.*)?)$ {
  return 302 $the_scheme://$the_host$the_prefix$1$is_args$args;
}

location /example/ {
  proxy_pass http://example/;
  proxy_intercept_errors on;
  error_page 502 503 504 /welcome/example-disabled.html;

  proxy_set_header X-Forwarded-Host $the_host;
  proxy_set_header X-Forwarded-Proto $the_scheme;
  proxy_set_header X-Forwarded-Path /example;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}

