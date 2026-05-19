[Unit]
Description=Docs Admin Panel
After=network.target syslog.target ifelse(regexp(M4_PACKAGE_NAME,`documentserver$'),-1,`redis-server.service')
ifelse(regexp(M4_PACKAGE_NAME,`documentserver$'),-1,`Wants=redis-server.service')

[Service]
Type=simple
User=ds
Group=ds
WorkingDirectory=/var/www/M4_DS_PREFIX/server/AdminPanel
ExecStart=/bin/sh -c 'exec /var/www/M4_DS_PREFIX/server/AdminPanel/server/adminpanel 2>&1 | tee -a /var/log/M4_DS_PREFIX/adminpanel/out.log'
Environment=NODE_ENV=production-linux NODE_CONFIG_DIR=/etc/M4_DS_PREFIX NODE_DISABLE_COLORS=1 APPLICATION_NAME=M4_COMPANY_NAME

Restart=always
RestartSec=30

# Give up if ping don't get an answer
TimeoutSec=600

[Install]
WantedBy=multi-user.target
