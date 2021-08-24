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
            if [ -f /var/run/nginx.pid ]; then
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
            if [ systemctl is-active supervisor.service -q ]; then
                systemctl restart supervisor.service > /dev/null
            elif [ systemctl is-active supervisord.service -q ]; then
                systemctl restart supervisord.service > /dev/null
            fi
        endscript
}
