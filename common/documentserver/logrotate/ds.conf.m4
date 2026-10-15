/var/log/M4_DS_PREFIX/nginx.error.log
/var/log/M4_DS_PREFIX/nginx.access.log {
        daily
        missingok
        rotate 30
        compress
        dateext
        delaycompress
        notifempty
        copytruncate
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
        copytruncate
}

/var/lib/M4_DS_PREFIX/App_Data/cache/files/errors/**/**/* {
        daily
        missingok
        notifempty
        nocompress
        nodateext
        nocreate
        rotate 0
        nocopytruncate
        sharedscripts

        prerotate
            find /var/lib/M4_DS_PREFIX/App_Data/cache/files/errors/ \
                -mindepth 2 -type d -mtime +30 -print -exec rm -rf {} +
        endscript
}
