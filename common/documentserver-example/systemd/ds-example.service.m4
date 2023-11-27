[Unit]
Description=Docs Example
After=network.target syslog.target

[Service]
Type=simple
User=ds
Group=ds
WorkingDirectory=/var/www/M4_DS_PREFIX-example
ExecStart=/bin/sh -c 'exec /var/www/M4_DS_PREFIX-example/example 2>&1 | tee -a /var/log/M4_DS_PREFIX-example/out.log'
Environment=NODE_ENV=production-linux NODE_CONFIG_DIR=/etc/M4_DS_PREFIX-example NODE_DISABLE_COLORS=1

Restart=always
RestartSec=30

# Give up if ping don't get an answer
TimeoutSec=600

[Install]
WantedBy=multi-user.target

