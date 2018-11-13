Source: PACKAGE_NAME
Section: web
Priority: optional
Maintainer: PUBLISHER_NAME <SUPPORT_MAIL>
Build-Depends: debhelper (>= 8.0.0)

Package: PACKAGE_NAME
Architecture: amd64
Depends: ${shlibs:Depends}, ${misc:Depends}, 
  adduser,
  coreutils,
  libasound2,
  libboost-regex-dev,
  libcairo2,
  libcurl3 | libcurl4,
  libcurl3-gnutls,
  libgconf-2-4,
  libgtkglext1,
  libstdc++6 (>= 4.8.4),
  libxml2,
  libxss1,
  libxtst6,
  logrotate,
  nginx-extras (>= 1.3.13),
  nodejs (>=8.0.0),
  postgresql-client (>= 9.1),
  pwgen,
  redis-tools,
  supervisor(>= 3.0b2),
  xvfb,
  zlib1g
Description: online viewers and editors for text, spreadsheet and presentation files.
 Compatible with most office file formats including Office Open XML formats:
 .docx, .xlsx, .pptx, and offer collaborative editing and commenting.
