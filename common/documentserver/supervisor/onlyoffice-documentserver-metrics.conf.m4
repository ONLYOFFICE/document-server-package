[program:metrics]
command=node /var/www/DS_PREFIX/server/Metrics/node_modules/statsd/stats.js ../../config/config.js
directory=/var/www/DS_PREFIX/server/Metrics/node_modules/statsd
user=onlyoffice
environment=NODE_DISABLE_COLORS=1
stdout_logfile=/var/log/DS_PREFIX/metrics/out.log
stdout_logfile_backups=0
stdout_logfile_maxbytes=0
stderr_logfile=/var/log/DS_PREFIX/metrics/err.log
stderr_logfile_backups=0
stderr_logfile_maxbytes=0
autostart=true
autorestart=true
