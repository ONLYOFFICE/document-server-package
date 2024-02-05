[Unit]
Description=Docs Docservice
After=network.target syslog.target redis-server.service ds-metrics.service
Wants=redis-server.service ds-metrics.service

[Service]
Type=simple
User=ds
Group=ds
WorkingDirectory=/var/www/M4_DS_PREFIX/server/DocService
ExecStart=/bin/sh -c 'exec /var/www/M4_DS_PREFIX/server/DocService/docservice 2>&1 | tee -a /var/log/M4_DS_PREFIX/docservice/out.log'
Environment=NODE_ENV=production-linux NODE_CONFIG_DIR=/etc/M4_DS_PREFIX NODE_DISABLE_COLORS=1

Restart=always
RestartSec=30

# Give up if ping don't get an answer
TimeoutSec=600

[Install]
WantedBy=multi-user.target

