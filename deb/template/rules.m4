#!/usr/bin/make -f
# -*- makefile -*-

export DH_VERBOSE=1

%:
	dh $@

override_dh_strip_nondeterminism:
	dh_strip_nondeterminism --exclude=.png

override_dh_shlibdeps:
	dh_shlibdeps --no-act

override_dh_strip:
	dh_strip -Xdocservice -Xconverter -Xmetrics -Xadminpanel -Xexample -Xjson -Xcore.node ifelse(M4_DEB_ARCH,amd64,`-Xarm64.node',`-Xx86_64.node')

execute_after_dh_fixperms:
	chmod o-rwx debian/M4_PACKAGE_NAME/etc/M4_DS_PREFIX/*.json

override_dh_builddeb:
	dh_builddeb -- -z9 -Zxz --threads-max=$(shell nproc)

override_dh_systemd_enable:
	dh_systemd_enable --no-enable

override_dh_systemd_start:
	dh_systemd_start --no-start --no-restart-after-upgrade --no-stop-on-upgrade
