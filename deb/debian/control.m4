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
  redis-tools,
  supervisor(>= 3.0b2),
  xvfb,
  zlib1g
Description: online viewers and editors for text, spreadsheet and presentation files.
 Compatible with most office file formats including Office Open XML formats:
 .docx, .xlsx, .pptx, and offer collaborative editing and commenting.
