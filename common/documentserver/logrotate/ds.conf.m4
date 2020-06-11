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
                service nginx reload > /dev/null
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
            if [ -f /var/run/supervisord.pid ]; then
                if [ ! -f /etc/redhat-release ]; then
                    service supervisor restart > /dev/null
                else
                    service supervisord restart > /dev/null
                fi
            fi
        endscript
}
