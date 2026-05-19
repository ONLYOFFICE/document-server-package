include(variables.m4)
Source: M4_PACKAGE_NAME
Section: web
Priority: optional
Maintainer: M4_PUBLISHER_NAME <M4_SUPPORT_MAIL>
Build-Depends: debhelper (>= 8.0.0)

Package: M4_PACKAGE_NAME
Architecture: M4_DEB_ARCH
Depends: ${shlibs:Depends}, ${misc:Depends}, 
  adduser,
  ca-certificates,
  certbot,
  coreutils,
  curl,
  libasound2 | libasound2t64,
  libcairo2,
  libcurl3 | libcurl4,
  libcurl3-gnutls,
  libgtk-3-0,
  libstdc++6 (>= 4.8.4),
  libxss1,
  libxtst6,
  logrotate,
  nginx-extras (>= 1.3.13),
ifelse(regexp(M4_PACKAGE_NAME,`documentserver$'),-1,
`  postgresql-client (>= 9.1) | mysql-client | mysql-community-client | mariadb-client, 
  redis-tools,'
,)dnl
  ttf-mscorefonts-installer,
  xvfb,
  openssl,
  xxd,
  zlib1g
Recommends:
Description: defn(`DEB[Summary]')
defn(`DEB[Description]')
