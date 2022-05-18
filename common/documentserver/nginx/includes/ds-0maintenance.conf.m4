location ~ ^(\/welcome\/.*)$ {
  expires 365d;
  alias /var/www/onlyoffice/documentserver/home/$1;
  index maintenance.html;
}
