location ~ ^(\/welcome\/.*)$ {
  expires 365d;
  alias /var/www/onlyoffice/documentserver-maintainer/$1;
  index maintains.html;
}
