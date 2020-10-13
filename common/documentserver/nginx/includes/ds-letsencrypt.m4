location ~ /.well-known/acme-challenge {
  root /var/www/M4_COMPANY_NAME/Data/certs/;
  allow all;
}
