[program:converter]
command=node --max_old_space_size=4096 --use-openssl-ca /var/www/M4_DS_PREFIX/server/FileConverter/sources/convertermaster.js
directory=/var/www/M4_DS_PREFIX/server/FileConverter/sources/
user=ds
environment=NODE_ENV=production-linux,NODE_CONFIG_DIR=/etc/M4_DS_PREFIX,NODE_DISABLE_COLORS=1
stdout_logfile=/var/log/M4_DS_PREFIX/converter/out.log
stdout_logfile_backups=0
stdout_logfile_maxbytes=0
stderr_logfile=/var/log/M4_DS_PREFIX/converter/err.log
stderr_logfile_backups=0
stderr_logfile_maxbytes=0
autostart=true
autorestart=true
