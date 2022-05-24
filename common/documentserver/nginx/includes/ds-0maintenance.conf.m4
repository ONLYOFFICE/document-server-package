location /index.html {
  expires 365d;
  root M4_DS_MAINTENANCE;
  index index.html;
}

rewrite ^/$ /index.html;
rewrite ^/welcome/(.+)$ /index.html;
rewrite ^/welcome$ /index.html;
