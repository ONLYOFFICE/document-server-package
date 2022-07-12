[Unit]
Description=Docs Metrics
After=network.target syslog.target

[Service]
Type=simple
User=ds
Group=ds
WorkingDirectory=/var/www/M4_DS_PREFIX/server/Metrics
ExecStart=/bin/sh -c '/var/www/M4_DS_PREFIX/server/Metrics/metrics ./config/config.js >>/var/log/M4_DS_PREFIX/metrics/out.log 2>>/var/log/M4_DS_PREFIX/metrics/err.log'
Environment=NODE_DISABLE_COLORS=1

Restart=always
RestartSec=30

# Give up if ping don't get an answer
TimeoutSec=600

[Install]
WantedBy=multi-user.target

