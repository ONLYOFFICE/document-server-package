location ~ ^(\/welcome\/.*)$ {
  expires 365d;
  alias /var/www/onlyoffice/documentserver/home/maintenance/$1;
  index maintenance.html;
}
