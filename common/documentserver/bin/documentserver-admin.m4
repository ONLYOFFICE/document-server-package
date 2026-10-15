#!/bin/bash

DIR="/var/www/M4_DS_PREFIX"
ADMINPANEL="$DIR/server/AdminPanel/server/adminpanel"

if [ "$(id -u)" -ne 0 ] && [ "$(id -un)" != "ds" ]; then
	echo "Root or ds privileges required. Try: sudo $(basename "$0") $*" >&2
	exit 1
fi

[ -x "$ADMINPANEL" ] || { echo "Admin Panel binary not found at $ADMINPANEL. The installation may be incomplete." >&2; exit 1; }

export NODE_ENV="${NODE_ENV:-production-linux}"
export NODE_CONFIG_DIR="${NODE_CONFIG_DIR:-/etc/M4_DS_PREFIX}"

cd "$DIR/server/AdminPanel" || exit 1

if [ "$(id -u)" -eq 0 ]; then
	exec runuser -u ds -- "$ADMINPANEL" --cli "$@"
fi

exec "$ADMINPANEL" --cli "$@"
