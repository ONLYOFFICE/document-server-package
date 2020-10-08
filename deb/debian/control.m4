include(variables.m4)
Source: M4_PACKAGE_NAME
Section: web
Priority: optional
Maintainer: M4_PUBLISHER_NAME <M4_SUPPORT_MAIL>
Build-Depends: debhelper (>= 8.0.0)

Package: M4_PACKAGE_NAME
Architecture: amd64
Depends: ${shlibs:Depends}, ${misc:Depends}, 
  adduser,
  ca-certificates,
  coreutils,
  curl,
  libasound2,
  libcairo2,
  libcurl3 | libcurl4,
  libcurl3-gnutls,
  libgconf-2-4,
  libgtk-3-0,
  libstdc++6 (>= 4.8.4),
  libxml2,
  libxss1,
  libxtst6,
  logrotate,
  mysql-client | mariadb-client,
  nginx-extras (>= 1.3.13),
  postgresql-client (>= 9.1),
  pwgen,
ifelse(eval(ifelse(M4_PRODUCT_NAME,documentserver-ee,1,0)||ifelse(M4_PRODUCT_NAME,documentserver-ie,1,0)||ifelse(M4_PRODUCT_NAME,documentserver-de,1,0)),1,
`  redis-tools,'
,)dnl
  supervisor(>= 3.0b2),
  ttf-mscorefonts-installer,
  xvfb,
  zlib1g
Description: defn(`DEB[Description]')
