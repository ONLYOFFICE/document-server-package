Requires: nginx >= 1.3.13, curl, wget, libstdc++ >= 4.8.4, libcurl, zlib, libXScrnSaver, atk, gtk3, xorg-x11-server-Xvfb, libXtst, alsa-lib, libselinux-utils, liberation-mono-fonts, logrotate, ca-certificates, certbot, msttcore-fonts-installer, openssl, vim-common
ifelse(regexp(M4_PACKAGE_NAME, `documentserver$'),-1,`Requires: /usr/bin/psql',)
