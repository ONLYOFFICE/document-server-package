include(variables.m4)
Source: M4_PACKAGE_NAME-example
Section: web
Priority: optional
Maintainer: M4_PUBLISHER_NAME <M4_SUPPORT_MAIL>
Build-Depends: debhelper (>= 8.0.0)

Package: M4_PACKAGE_NAME-example
Architecture: M4_DEB_ARCH
Depends: ${shlibs:Depends}, ${misc:Depends}, 
  nginx-extras (>= 1.3.13)
Recommends:
Description: defn(`DEB[Summary]')
defn(`DEB[Description]')
