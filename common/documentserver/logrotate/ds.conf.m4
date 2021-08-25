/var/log/M4_DS_PREFIX/nginx.error.log {
        daily
        missingok
        rotate 30
        compress
        dateext
        delaycompress
        notifempty
        sharedscripts
        postrotate
            if systemctl is-active nginx -q; then
                systemctl reload nginx > /dev/null
            fi
        endscript
}

/var/log/M4_DS_PREFIX/**/*.log
/var/log/M4_DS_PREFIX-example/*.log {
        daily
        missingok
        rotate 30
        compress
        dateext
        delaycompress
        notifempty
        nocreate
        sharedscripts
        postrotate
            if systemctl is-active supervisor -q; then
                systemctl restart supervisor > /dev/null
            elif systemctl is-active supervisord -q; then
                systemctl restart supervisord > /dev/null
            fi
        endscript
}
