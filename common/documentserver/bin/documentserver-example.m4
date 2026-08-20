#!/bin/bash

[ "$(id -u)" -ne 0 ] && [ "$(id -un)" != "ds" ] && { echo "Root or ds privileges required"; exit 1; }

case "$1" in
    start|stop|status) ;;
    *) echo "Usage: $(basename "$0") {start|stop|status}" >&2; exit 1 ;;
esac

if pgrep -x "systemd" >/dev/null; then
    systemctl "$1" ds-example
elif pgrep -x "supervisord" >/dev/null; then
    supervisorctl "$1" ds:example
else
    echo "Neither systemd nor supervisord is running" >&2
    exit 1
fi
