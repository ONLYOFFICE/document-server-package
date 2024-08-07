#!/bin/sh

if [ "$1" != "" ]; then
    RESTART_CONDITION=$1
fi

# Generate a SHA256 hash of the datetime
hash=$(echo -n "$(date +'%Y.%m.%d-%H%M')" | md5sum | awk '{print $1}')

# Save the hash to a variable in the configuration file
echo "set \$cache_tag \"$hash\";" > /etc/nginx/includes/ds-cache.conf

if [ "$RESTART_CONDITION" != "false" ]; then
	[ $(pgrep -x ""systemd"" | wc -l) -gt 0 ] && systemctl reload nginx || service nginx reload
fi
