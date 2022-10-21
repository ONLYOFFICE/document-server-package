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
            if pgrep -x "nginx" >/dev/null; then
              service nginx restart;
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
            if pgrep -x ""systemd"" >/dev/null; then
                for SVC in M4_PACKAGE_SERVICES ds-example; do
                    if systemctl is-active $SVC | grep -q "active"; then
                        systemctl restart $SVC > /dev/null
                    fi
                done
            elif pgrep -x ""supervisord"" >/dev/null; then
                service supervisor restart
            fi
        endscript
}
