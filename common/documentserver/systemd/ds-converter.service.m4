[Unit]
Description=Docs Converter
After=network.target syslog.target redis-server.service ds-metrics.service
Wants=redis-server.service ds-metrics.service

[Service]
Type=simple
User=ds
Group=ds
WorkingDirectory=/var/www/M4_DS_PREFIX/server/FileConverter
ExecStart=/bin/sh -c '/var/www/M4_DS_PREFIX/server/FileConverter/converter >>/var/log/M4_DS_PREFIX/converter/out.log 2>>/var/log/M4_DS_PREFIX/converter/err.log'
Environment=NODE_ENV=production-linux NODE_CONFIG_DIR=/etc/M4_DS_PREFIX NODE_DISABLE_COLORS=1 APPLICATION_NAME=M4_COMPANY_NAME

Restart=always
RestartSec=30

# Give up if ping don't get an answer
TimeoutSec=600

[Install]
WantedBy=multi-user.target

