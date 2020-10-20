location ~ /.well-known/acme-challenge {
  root M4_DS_ROOT/letsencrypt/;
  allow all;
}
