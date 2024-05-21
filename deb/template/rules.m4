#!/usr/bin/make -f
# -*- makefile -*-

export DH_VERBOSE=1

%:
	dh $@

override_dh_shlibdeps:

override_dh_strip:
	dh_strip -Xdocservice -Xconverter -Xmetrics -Xexample -Xjson -Xcore.node

execute_after_dh_fixperms:
	chmod o-rwx debian/M4_PACKAGE_NAME/etc/M4_DS_PREFIX/*.json
