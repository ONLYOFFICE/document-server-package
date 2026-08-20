#!/bin/bash
set -euo pipefail
umask 022

LETSENCRYPT_ROOT_DIR="/etc/letsencrypt/live"
ROOT_DIR="M4_DS_ROOT/letsencrypt"
NGINX_CONF_DIR="/etc/M4_DS_PREFIX/nginx"

if [ "$#" -ge "2" ]; then
    LETS_ENCRYPT_MAIL="$1"
    LETS_ENCRYPT_DOMAIN="$2"

    if ! [[ "$LETS_ENCRYPT_DOMAIN" =~ ^([A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+[A-Za-z]{2,63}$ ]]; then
        echo "Bad DOMAIN: $LETS_ENCRYPT_DOMAIN" >&2
        exit 2
    fi

    if ! [[ "$LETS_ENCRYPT_MAIL" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,63}(,[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,63})*$ ]]; then
        echo "Bad EMAIL list: $LETS_ENCRYPT_MAIL" >&2
        exit 2
    fi

    SSL_CERT="${LETSENCRYPT_ROOT_DIR}/${LETS_ENCRYPT_DOMAIN}/fullchain.pem"
    SSL_KEY="${LETSENCRYPT_ROOT_DIR}/${LETS_ENCRYPT_DOMAIN}/privkey.pem"

    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    mkdir -p -- "$ROOT_DIR"

    command -v certbot >/dev/null 2>&1 || { echo "certbot not found" >&2; exit 5; }
    printf 'certbot certonly --expand --webroot -w %q --noninteractive --agree-tos --email %q -d %q\n' "$ROOT_DIR" "$LETS_ENCRYPT_MAIL" "$LETS_ENCRYPT_DOMAIN" > /var/log/le-start.log
    certbot certonly --expand --webroot -w "$ROOT_DIR" --noninteractive --agree-tos --email "$LETS_ENCRYPT_MAIL" -d "$LETS_ENCRYPT_DOMAIN" 2>&1 | tee /var/log/le-new.log

    if [ -f "$SSL_CERT" ] && [ -f "$SSL_KEY" ]; then
        if [ -f "${NGINX_CONF_DIR}/ds-ssl.conf.tmpl" ]; then
            SECURE_LINK_SECRET="$(grep -oP '(?<=secure_link_secret ).*(?=;)' "${NGINX_CONF_DIR}/ds.conf" | head -n 1 || true)"
            [ -z "$SECURE_LINK_SECRET" ] && { echo "secure_link_secret not found in ${NGINX_CONF_DIR}/ds.conf" >&2; exit 3; }

            SECURE_LINK_SECRET_ESC="$(printf '%s' "$SECURE_LINK_SECRET" | tr -d '\r\n' | sed 's/^"\(.*\)"$/\1/; s/[\\&|]/\\&/g')"
            SSL_CERT_ESC="$(printf '%s' "$SSL_CERT" | sed 's/[\\&|]/\\&/g')"
            SSL_KEY_ESC="$(printf '%s' "$SSL_KEY" | sed 's/[\\&|]/\\&/g')"  

            cp -f -- "${NGINX_CONF_DIR}/ds-ssl.conf.tmpl" "${NGINX_CONF_DIR}/ds.conf"
            sed -e "s|^[[:space:]]*set[[:space:]]\+\$secure_link_secret[[:space:]]\+.*;|set \$secure_link_secret \"${SECURE_LINK_SECRET_ESC}\";|" \
                -e "s|{{SSL_CERTIFICATE_PATH}}|${SSL_CERT_ESC}|g" \
                -e "s|{{SSL_KEY_PATH}}|${SSL_KEY_ESC}|g" -i "${NGINX_CONF_DIR}/ds.conf" 
        fi
    fi

    command -v nginx >/dev/null 2>&1 && nginx -t
    if pgrep -x systemd >/dev/null 2>&1 && command -v systemctl >/dev/null 2>&1; then
        NGINX_RELOAD_CMD=(systemctl reload nginx)
    elif command -v service >/dev/null 2>&1; then
        NGINX_RELOAD_CMD=(service nginx reload)
    elif command -v nginx >/dev/null 2>&1; then
        NGINX_RELOAD_CMD=(nginx -s reload)
    fi
    [ -n "${NGINX_RELOAD_CMD:-}" ] && "${NGINX_RELOAD_CMD[@]}" || { echo "Failed to determine nginx reload command" >&2; exit 4; }

    cat > "${DIR}/letsencrypt_cron.sh" <<END
#!/usr/bin/env bash
certbot renew --deploy-hook "${NGINX_RELOAD_CMD[*]}" >> /var/log/le-renew.log 2>&1
END

    chmod 0755 -- "${DIR}/letsencrypt_cron.sh"
    cat > /etc/cron.d/letsencrypt <<END
@weekly root ${DIR}/letsencrypt_cron.sh
END

    chmod 0644 -- "/etc/cron.d/letsencrypt"
else
    echo "This script provided to automatically get Let's Encrypt SSL Certificates for Document Server"
    echo "usage:"
    echo "  documentserver-letsencrypt EMAIL DOMAIN"
    echo "      EMAIL       Email used for registration and recovery contact. Use"
    echo "                  comma to register multiple emails, ex:"
    echo "                  u1@example.com,u2@example.com."
    echo "      DOMAIN      Domain name to apply"
fi
