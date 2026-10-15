# -- system
Requires: libselinux-utils
Requires: /usr/sbin/semanage
Requires: ca-certificates
Requires: libstdc++ >= 4.8.4
# -- web server
Requires: nginx >= 1.18
# -- tools
# vim-common provides xxd, used for WOPI modulus decoding
Requires: vim-common
Requires: logrotate
Requires: openssl
Requires: curl
Requires: iproute
# -- fonts
Requires: liberation-mono-fonts
Requires: msttcore-fonts-installer
# -- enterprise/developer editions only
ifelse(regexp(M4_PACKAGE_NAME, `documentserver$'),-1,`Requires: certbot, python3-certbot-nginx',)
