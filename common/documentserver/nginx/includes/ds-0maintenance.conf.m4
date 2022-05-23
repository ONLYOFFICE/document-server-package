location ~ ^(\/welcome\/.*)$ {
  expires 365d;
  alias M4_DS_MAINTENANCE$1;
  index index.html;
}
