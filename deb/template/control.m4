include(variables.m4)
Source: M4_PACKAGE_NAME
Section: web
Priority: optional
Maintainer: M4_PUBLISHER_NAME <M4_SUPPORT_MAIL>
Build-Depends: debhelper (>= 8.0.0)

Package: M4_PACKAGE_NAME
Architecture: M4_DEB_ARCH
Depends: ${shlibs:Depends}, ${misc:Depends}, 
  M4_PACKAGE_NAME-core,
  M4_PACKAGE_NAME-example
Recommends:
Description: defn(`DEB[Summary]')
defn(`DEB[Description]')
