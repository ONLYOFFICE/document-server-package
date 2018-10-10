location ~ ^(\/welcome\/.*)$ {
  expires 365d;
  alias M4_DS_EXAMLE$1;
  index M4_PLATFORM.html;
}

location /example/ {
  proxy_pass http://example/;

  proxy_set_header Host $the_host/example;
  proxy_set_header X-Forwarded-Proto $the_scheme;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}

