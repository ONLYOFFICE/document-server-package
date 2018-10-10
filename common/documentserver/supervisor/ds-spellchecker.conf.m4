[program:spellchecker]
command=node /var/www/M4_DS_PREFIX/server/SpellChecker/sources/server.js
directory=/var/www/M4_DS_PREFIX/server/SpellChecker/sources/
user=ds
environment=NODE_ENV=production-linux,NODE_CONFIG_DIR=/etc/M4_DS_PREFIX,NODE_DISABLE_COLORS=1
stdout_logfile=/var/log/M4_DS_PREFIX/spellchecker/out.log
stdout_logfile_backups=0
stdout_logfile_maxbytes=0
stderr_logfile=/var/log/M4_DS_PREFIX/spellchecker/err.log
stderr_logfile_backups=0
stderr_logfile_maxbytes=0
autostart=true
autorestart=true
