location ~ /.well-known/acme-challenge {
  root M4_DS_ROOT/../Data/certs/;
  allow all;
}
