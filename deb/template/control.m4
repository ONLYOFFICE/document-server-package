include(variables.m4)
Source: M4_PACKAGE_NAME
Section: web
Priority: optional
Maintainer: M4_PUBLISHER_NAME <M4_SUPPORT_MAIL>
Build-Depends: debhelper (>= 8.0.0)

Package: M4_PACKAGE_NAME
Architecture: M4_DEB_ARCH
Depends: ${shlibs:Depends}, ${misc:Depends},
dnl -- system
  adduser,
  libstdc++6 (>= 10),
  ca-certificates,
dnl -- web server
  nginx (>= 1.22) | nginx-extras (>= 1.18),
dnl -- tools
  xxd,
  curl,
  openssl,
  iproute2,
  logrotate,
dnl -- fonts
  ttf-mscorefonts-installer,
dnl -- enterprise/developer editions only
ifelse(regexp(M4_PACKAGE_NAME,`documentserver$'),-1,
`  postgresql-client (>= 12) | mysql-client (>= 8.0) | mysql-community-client (>= 8.0) | mariadb-client (>= 10.3),
  certbot,
  redis-tools,'
,)dnl
Description: defn(`DEB[Summary]')
defn(`DEB[Description]')
