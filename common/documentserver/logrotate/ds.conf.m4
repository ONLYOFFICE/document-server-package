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
            for SVC in M4_PACKAGE_SERVICES; do
                if [ -e /usr/lib/systemd/system/$SVC.service ]; then
                    service $SVC restart > /dev/null
                fi
            done
        endscript
}
