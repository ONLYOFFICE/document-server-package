PWD := $(shell pwd)
CURL := curl -s -L -o
TOUCH := touch

COMPANY_NAME ?= ONLYOFFICE
PRODUCT_NAME ?= DocumentServer
PRODUCT_SHORT_NAME ?= $(firstword $(subst -, ,$(PRODUCT_NAME)))

COMPANY_NAME_LOW = $(shell echo $(COMPANY_NAME) | tr A-Z a-z)
PRODUCT_NAME_LOW = $(shell echo $(PRODUCT_NAME) | tr A-Z a-z)
PRODUCT_SHORT_NAME_LOW = $(shell echo $(PRODUCT_SHORT_NAME) | tr A-Z a-z)

PUBLISHER_NAME ?= Ascensio System SIA
PUBLISHER_URL ?= http://onlyoffice.com
SUPPORT_URL ?= http://support.onlyoffice.com
SUPPORT_MAIL ?= support@onlyoffice.com

PRODUCT_VERSION ?= 0.0.0
BUILD_NUMBER ?= 0

BRANDING_DIR ?= .

PACKAGE_NAME := $(COMPANY_NAME_LOW)-$(PRODUCT_NAME_LOW)
PACKAGE_VERSION := $(PRODUCT_VERSION)-$(BUILD_NUMBER)

UNAME_M ?= $(shell uname -m)
ifeq ($(UNAME_M),x86_64)
	RPM_ARCH := x86_64
	DEB_ARCH := amd64
	TAR_ARCH := x86_64
endif
ifneq ($(filter aarch%,$(UNAME_M)),)
	RPM_ARCH := aarch64
	DEB_ARCH := arm64
	TAR_ARCH := aarch64
endif

APT_RPM_BUILD_DIR = $(PWD)/apt-rpm/builddir
RPM_BUILD_DIR = $(PWD)/rpm/builddir
EXE_BUILD_DIR = exe

APT_RPM_PACKAGE_DIR = $(APT_RPM_BUILD_DIR)/RPMS/$(RPM_ARCH)
RPM_PACKAGE_DIR = $(RPM_BUILD_DIR)/RPMS/$(RPM_ARCH)
TAR_PACKAGE_DIR = $(PWD)

APT_RPM = $(APT_RPM_PACKAGE_DIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION)$(APT_RPM_RELEASE_SUFFIX).$(RPM_ARCH).rpm
RPM = $(RPM_PACKAGE_DIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION)$(RPM_RELEASE_SUFFIX).$(RPM_ARCH).rpm
DEB = deb/$(PACKAGE_NAME)_$(PACKAGE_VERSION)_$(DEB_ARCH)$(DEB_RELEASE_SUFFIX).deb
EXE = $(EXE_BUILD_DIR)/$(COMPANY_NAME)-$(PRODUCT_NAME)-$(PRODUCT_VERSION).$(BUILD_NUMBER)-x64.exe
EXE_PR = $(EXE_BUILD_DIR)/$(COMPANY_NAME)-$(PRODUCT_NAME)-Prerequisites-$(PRODUCT_VERSION).$(BUILD_NUMBER)-x64.exe
TAR = $(TAR_PACKAGE_DIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION)$(TAR_RELEASE_SUFFIX)-$(TAR_ARCH).tar.gz

PACKAGE_SERVICES ?= ds-docservice ds-converter ds-metrics

DOCUMENTSERVER = common/documentserver/home
DOCUMENTSERVER_BIN = common/documentserver/bin
DOCUMENTSERVER_CONFIG = common/documentserver/config
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/core-fonts
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/license
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/web-apps
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/server
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/sdkjs
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/sdkjs-plugins

3RD_PARTY_LICENSE_FILES += $(DOCUMENTSERVER)/server/LICENSE.txt 
3RD_PARTY_LICENSE_FILES += $(DOCUMENTSERVER)/server/3rd-Party.txt 
3RD_PARTY_LICENSE_FILES += $(DOCUMENTSERVER)/server/license

LICENSE_FILE = $(BRANDING_DIR)/common/documentserver/license/$(PACKAGE_NAME)/LICENSE.txt
HTMLFILEINTERNAL = $(DOCUMENTSERVER)/server/FileConverter/bin/HtmlFileInternal/HtmlFileInternal

DOCUMENTSERVER_EXAMPLE = common/documentserver-example/home
DOCUMENTSERVER_EXAMPLE_CONFIG = common/documentserver-example/config

FONTS = common/fonts

NGINX_VER := nginx-1.21.3
NGINX_ZIP := $(NGINX_VER).zip
NGINX := $(DOCUMENTSERVER)/nginx

DS_MIME_TYPES = common/documentserver/nginx/includes/ds-mime.types.conf

PSQL := $(DOCUMENTSERVER)/pgsql/bin
PSQL_ZIP := postgresql-10.20-2-windows-x64-binaries.zip

WINSW := $(EXE_BUILD_DIR)/winsw/WinSW-x64.exe

PYTHON := $(EXE_BUILD_DIR)/redist/python-3.11.3-amd64.exe
OPENSSL := $(EXE_BUILD_DIR)/redist/FireDaemon-OpenSSL-x64-3.3.0.exe
RABBITMQ := $(EXE_BUILD_DIR)/redist/rabbitmq-server-3.12.11.exe
ERLANG := $(EXE_BUILD_DIR)/redist/otp_win64_26.2.1.exe
POSTGRESQL := $(EXE_BUILD_DIR)/redist/postgresql-12.17-1-windows-x64.exe
REDIS := $(EXE_BUILD_DIR)/redist/Redis-x64-5.0.10.msi
CERTBOT := $(EXE_BUILD_DIR)/redist/certbot-2.6.0.exe
VC2013 := $(EXE_BUILD_DIR)/redist/vcredist2013_x64.exe
VC2022 := $(EXE_BUILD_DIR)/redist/vcredist2022_x64.exe

BUILD_DATE := $(shell date +%F-%H-%M)

WEBAPPS_DIR := web-apps
SDKJS_DIR :=sdkjs

ifeq ($(PRODUCT_NAME_LOW),$(filter $(PRODUCT_NAME_LOW),documentserver))
OFFICIAL_PRODUCT_NAME := 'Community Edition'
endif

ifeq ($(PRODUCT_NAME_LOW),$(filter $(PRODUCT_NAME_LOW),documentserver-ee))
OFFICIAL_PRODUCT_NAME := 'Enterprise Edition'
endif

ifeq ($(PRODUCT_NAME_LOW),$(filter $(PRODUCT_NAME_LOW),documentserver-ie))
OFFICIAL_PRODUCT_NAME := 'Integration Edition'
endif

ifeq ($(PRODUCT_NAME_LOW),$(filter $(PRODUCT_NAME_LOW),documentserver-de))
OFFICIAL_PRODUCT_NAME := 'Developer Edition'
endif

ifeq ($(OS),Windows_NT)
	PLATFORM := win
	EXEC_EXT := .exe
	SHELL_EXT := .bat
	SHARED_EXT := .dll
	ARCH_EXT := .zip
	AR := 7z a -y
	PACKAGES = exe
	NGINX_CONF := includes
	NGINX_LOG := logs
	DS_ROOT := ..
	DS_FILES := ../server
	DS_EXAMLE := ../example
	DEV_NULL := nul
	ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
		ARCHITECTURE := 64
	endif
	ifeq ($(PROCESSOR_ARCHITECTURE),x86)
		ARCHITECTURE := 32
	endif
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		PLATFORM := linux
		SHARED_EXT := .so*
		SHELL_EXT := .sh
		ARCH_EXT := .zip
		AR := 7z a -y
		PACKAGES = deb rpm tar apt-rpm
		DS_PREFIX := $(COMPANY_NAME_LOW)/$(PRODUCT_SHORT_NAME_LOW)
		NGINX_CONF := /etc/nginx/includes
		NGINX_LOG := /var/log/$(DS_PREFIX)
		DS_ROOT := /var/www/$(DS_PREFIX)
		DS_FILES := /var/lib/$(DS_PREFIX)
		DS_EXAMLE := /var/www/$(DS_PREFIX)-example
		DEV_NULL := /dev/null
	endif
	ifeq ($(UNAME_S),Darwin)
		PLATFORM := mac
		SHARED_EXT := .dylib
		SHELL_EXT := .sh
		ARCH_EXT := .zip
		AR := 7z a -y
		NGINX_CONF := /etc/nginx/
		NGINX_LOG := /var/log/onlyoffice/documentserver/
		NGINX_CASH := /var/cache/nginx/onlyoffice/documentserver/
		DS_ROOT := /var/www/onlyoffice/documentserver/
		DS_FILES := /var/lib/onlyoffice/documentserver/
		DS_EXAMLE := /var/www/onlyoffice/documentserver-example
		DEV_NULL := /dev/null
	endif
	ifeq ($(UNAME_M),x86_64)
		ARCHITECTURE := 64
		PKG_TARGET ?= node18-linux-x64
	endif
	ifneq ($(filter %86,$(UNAME_M)),)
		ARCHITECTURE := 32
	endif
	ifneq ($(filter aarch%,$(UNAME_M)),)
		ARCHITECTURE := arm64
		PKG_TARGET ?= node18-linux-arm64
	endif
endif

TARGET := $(PLATFORM)_$(ARCHITECTURE)
DS_BIN_REPO := ./ds-repo
DS_BIN := ./$(TARGET)/ds-bin-$(PRODUCT_VERSION)$(ARCH_EXT)

ISCC := iscc
ISCC_PARAMS += -Qp
ISCC_PARAMS += -DVERSION=$(PRODUCT_VERSION).$(BUILD_NUMBER)
ifeq ($(PRODUCT_NAME_LOW),$(filter $(PRODUCT_NAME_LOW),documentserver))
ISCC_PARAMS += -DEDITION=community
else ifeq ($(PRODUCT_NAME_LOW),$(filter $(PRODUCT_NAME_LOW),documentserver-de))
ISCC_PARAMS += -DEDITION=developer
else ifeq ($(PRODUCT_NAME_LOW),$(filter $(PRODUCT_NAME_LOW),documentserver-ee))
ISCC_PARAMS += -DEDITION=enterprise
endif
ISCC_PARAMS += -DBRANDING_DIR='$(shell cygpath -a -w "$(BRANDING_DIR)/exe")'
ifdef ENABLE_SIGNING
ISCC_PARAMS += -DSIGN
ISCC_PARAMS += -S'byparam=signtool.exe sign /a /v /n $(firstword $(PUBLISHER_NAME)) /t http://timestamp.digicert.com $$f'
endif

EXE_PR_DEPS := $(POSTGRESQL) $(CERTBOT) $(REDIS) $(ERLANG) $(RABBITMQ) $(OPENSSL) $(PYTHON) $(VC2013) $(VC2022)

DEB_DEPS += deb/build/debian/source/format
DEB_DEPS += deb/build/debian/changelog
DEB_DEPS += deb/build/debian/compat
DEB_DEPS += deb/build/debian/config
DEB_DEPS += deb/build/debian/control
DEB_DEPS += deb/build/debian/copyright
DEB_DEPS += deb/build/debian/postinst
DEB_DEPS += deb/build/debian/postrm
DEB_DEPS += deb/build/debian/prerm
DEB_DEPS += deb/build/debian/rules
DEB_DEPS += deb/build/debian/templates
DEB_DEPS += deb/build/debian/triggers
DEB_DEPS += deb/build/debian/$(PACKAGE_NAME).install
DEB_DEPS += deb/build/debian/$(PACKAGE_NAME).links
DEB_DEPS += deb/build/debian/$(PACKAGE_NAME).dirs

COMMON_DEPS += common/documentserver/nginx/includes/ds-common.conf
COMMON_DEPS += common/documentserver/nginx/includes/ds-docservice.conf
COMMON_DEPS += common/documentserver/nginx/includes/ds-letsencrypt.conf
COMMON_DEPS += common/documentserver/nginx/includes/http-common.conf
COMMON_DEPS += common/documentserver/nginx/ds-ssl.conf.tmpl
COMMON_DEPS += common/documentserver/nginx/ds.conf.tmpl
COMMON_DEPS += common/documentserver/nginx/ds.conf
COMMON_DEPS += common/documentserver-example/nginx/includes/ds-example.conf
COMMON_DEPS += $(DS_MIME_TYPES)

LINUX_DEPS += common/documentserver/logrotate/ds.conf

#Prevent copy old artifacts
LINUX_DEPS_CLEAN += common/documentserver/logrotate/*.conf

LINUX_DEPS += common/documentserver/systemd/ds-converter.service
LINUX_DEPS += common/documentserver/systemd/ds-docservice.service
LINUX_DEPS += common/documentserver/systemd/ds-metrics.service
LINUX_DEPS += common/documentserver-example/systemd/ds-example.service

LINUX_DEPS_CLEAN += common/documentserver/systemd/*.service
LINUX_DEPS_CLEAN += common/documentserver-example/systemd/*.service

LINUX_DEPS += $(basename $(wildcard common/documentserver/bin/*.sh.m4))

ifneq ($(COMPANY_NAME_LOW),onlyoffice)
LINUX_DEPS := $(filter-out common/documentserver/bin/documentserver-pluginsmanager.sh,$(LINUX_DEPS))
PLUGIN_MANAGER_FILE := $(wildcard common/documentserver/bin/documentserver-pluginsmanager.sh.m4)
endif

LINUX_DEPS_CLEAN += common/documentserver/bin/*.sh

LINUX_DEPS += rpm/$(PACKAGE_NAME).spec
LINUX_DEPS += apt-rpm/$(PACKAGE_NAME).spec

LINUX_DEPS_CLEAN += rpm/$(PACKAGE_NAME).spec
LINUX_DEPS_CLEAN += apt-rpm/$(PACKAGE_NAME).spec

LINUX_DEPS += rpm/bin/documentserver-configure.sh
LINUX_DEPS += apt-rpm/bin/documentserver-configure.sh

LINUX_DEPS_CLEAN += rpm/bin/*.sh
LINUX_DEPS_CLEAN += apt-rpm/bin/*.sh

ifeq ($(COMPANY_NAME_LOW),onlyoffice)
ONLYOFFICE_VALUE := onlyoffice
else
ONLYOFFICE_VALUE := ds
endif

M4_PARAMS += -D M4_COMPANY_NAME=$(COMPANY_NAME)
M4_PARAMS += -D M4_PACKAGE_NAME=$(PACKAGE_NAME)
M4_PARAMS += -D M4_PRODUCT_NAME=$(PRODUCT_NAME)
M4_PARAMS += -D M4_PRODUCT_VERSION=$(PRODUCT_VERSION)
M4_PARAMS += -D M4_PACKAGE_VERSION=$(PACKAGE_VERSION)
M4_PARAMS += -D M4_PUBLISHER_NAME='$(PUBLISHER_NAME)'
M4_PARAMS += -D M4_PUBLISHER_URL='$(PUBLISHER_URL)'
M4_PARAMS += -D M4_SUPPORT_MAIL='$(SUPPORT_MAIL)'
M4_PARAMS += -D M4_SUPPORT_URL='$(SUPPORT_URL)'
M4_PARAMS += -D M4_BRANDING_DIR='$(abspath $(BRANDING_DIR))'
M4_PARAMS += -D M4_ONLYOFFICE_VALUE=$(ONLYOFFICE_VALUE)
M4_PARAMS += -D M4_PLATFORM=$(PLATFORM)
M4_PARAMS += -D M4_DEB_ARCH='$(DEB_ARCH)'
M4_PARAMS += -D M4_NGINX_CONF='$(NGINX_CONF)'
M4_PARAMS += -D M4_NGINX_LOG='$(NGINX_LOG)'
M4_PARAMS += -D M4_DS_PREFIX='$(DS_PREFIX)'
M4_PARAMS += -D M4_DS_ROOT='$(DS_ROOT)'
M4_PARAMS += -D M4_DS_FILES='$(DS_FILES)'
M4_PARAMS += -D M4_DS_EXAMLE='$(DS_EXAMLE)'
M4_PARAMS += -D M4_DEV_NULL='$(DEV_NULL)'
M4_PARAMS += -D M4_PACKAGE_SERVICES='$(PACKAGE_SERVICES)'

.PHONY: all clean clean-docker rpm deb exe exe-pr packages deploy-bin

all: rpm deb apt-rpm

apt-rpm:$(APT_RPM)

rpm: $(RPM)

rpm_aarch64 : TARGET = linux_arm64
rpm_aarch64 : RPM_ARCH = aarch64
rpm_aarch64 : $(RPM)

deb: $(DEB)

exe: $(EXE)
exe-pr: $(EXE_PR)

tar: $(TAR)

clean:
	rm -rf \
		deb/build \
		deb/*.buildinfo \
		deb/*.changes \
		deb/*.ddeb \
		deb/*.deb \
		$(APT_RPM_BUILD_DIR)\
		$(RPM_BUILD_DIR)\
		$(TAR_PACKAGE_DIR)/*.tar.gz\
		$(EXE_BUILD_DIR)/*.exe\
		$(NGINX)\
		$(WINSW)\
		$(PSQL)\
		$(DS_BIN_REPO)\
		$(DOCUMENTSERVER_FILES)\
		$(DOCUMENTSERVER_EXAMPLE)\
		$(DS_BIN)\
		$(FONTS)\
		$(COMMON_DEPS)\
		$(LINUX_DEPS_CLEAN)\
		documentserver\
		documentserver-example
		
documentserver:
	mkdir -p $(DOCUMENTSERVER_FILES)
	cp -rf -t $(DOCUMENTSERVER) ../build_tools/out/$(TARGET)/$(COMPANY_NAME_LOW)/$(PRODUCT_SHORT_NAME_LOW)/*

	mkdir -p $(DOCUMENTSERVER_CONFIG)
	mkdir -p $(DOCUMENTSERVER_CONFIG)/log4js

	mv -f $(DOCUMENTSERVER)/server/Common/config/*.json $(DOCUMENTSERVER_CONFIG)
	mv -f $(DOCUMENTSERVER)/server/Common/config/log4js/*.json $(DOCUMENTSERVER_CONFIG)/log4js/

	# rename product specific folders
	sed "s|onlyoffice\/documentserver|"$(DS_PREFIX)"|"  -i $(DOCUMENTSERVER_CONFIG)/*.json

	# rename db account params
	sed 's|\("db.*": "\)onlyoffice\("\)|\1'$(ONLYOFFICE_VALUE)'\2|'  -i $(DOCUMENTSERVER_CONFIG)/*.json

	# rename db schema name
	sed 's|onlyoffice|'$(ONLYOFFICE_VALUE)'|'  -i $(DOCUMENTSERVER)/server/schema/**/*.sql

	# ignore CREATE DATABASE commands in MySQL
	sed -r "s/^(CREATE DATABASE|USE)/-- \1/" -i $(DOCUMENTSERVER)/server/schema/mysql/*.sql

	# rename product in license
	sed 's|ONLYOFFICE|'$(COMPANY_NAME)'|'  -i $(DOCUMENTSERVER)/server/3rd-Party.txt
	sed 's|DocumentServer|'$(PRODUCT_NAME)'|'  -i $(DOCUMENTSERVER)/server/3rd-Party.txt

	# Prevent for modification original config
	chmod ug=r $(DOCUMENTSERVER_CONFIG)/*.json

	cp -fr -t $(DOCUMENTSERVER) $(3RD_PARTY_LICENSE_FILES)
	rm -fr $(3RD_PARTY_LICENSE_FILES)

ifeq ($(PLATFORM),win)
	cp -fr -t $(DOCUMENTSERVER)/license exe/license/*.license
	echo ; >> $(DOCUMENTSERVER)/3rd-Party.txt
	cat exe/license/3rd-Party.txt ; >> $(DOCUMENTSERVER)/3rd-Party.txt
endif

	[ -f $(LICENSE_FILE) ] \
		&& cp -f -t $(DOCUMENTSERVER) $(LICENSE_FILE) \
		|| cp -f -t $(DOCUMENTSERVER) LICENSE.txt

	chmod u+x $(DOCUMENTSERVER)/server/FileConverter/bin/x2t$(EXEC_EXT)
	#chmod u+x $(DOCUMENTSERVER)/server/FileConverter/bin/docbuilder$(EXEC_EXT)
	[ -f $(HTMLFILEINTERNAL)$(EXEC_EXT) ] && chmod u+x $(HTMLFILEINTERNAL)$(EXEC_EXT) || true
	chmod u+x $(DOCUMENTSERVER)/server/tools/allfontsgen$(EXEC_EXT)

	mv -f $(DOCUMENTSERVER)/web-apps/apps/api/documents/api.js $(DOCUMENTSERVER)/web-apps/apps/api/documents/api.js.tpl
	sed "s|\(_dc=\)0|\1"$(PACKAGE_VERSION)"|"  -i $(DOCUMENTSERVER)/web-apps/apps/api/documents/api.js.tpl

ifeq ($(PRODUCT_NAME_LOW), documentserver)
	sed 's|\("packageType": \)[0-9]\+\(.*\)|\10\2|' -i $(DOCUMENTSERVER_CONFIG)/*.json
	sed 's|\("editorDataStorage": "\).\+\(".*\)|\1editorDataMemory\2|' -i $(DOCUMENTSERVER_CONFIG)/*.json
endif

ifeq ($(PRODUCT_NAME_LOW), $(filter $(PRODUCT_NAME_LOW),documentserver-ee documentserver-ie))
	sed 's|\("packageType": \)[0-9]\+\(.*\)|\11\2|' -i $(DOCUMENTSERVER_CONFIG)/*.json
	sed 's|\("editorDataStorage": "\).\+\(".*\)|\1editorDataRedis\2|' -i $(DOCUMENTSERVER_CONFIG)/*.json
endif

ifeq ($(PRODUCT_NAME_LOW), documentserver-de)
	sed 's|\("packageType": \)[0-9]\+\(.*\)|\12\2|' -i $(DOCUMENTSERVER_CONFIG)/*.json
	sed 's|\("editorDataStorage": "\).\+\(".*\)|\1editorDataRedis\2|' -i $(DOCUMENTSERVER_CONFIG)/*.json
endif

	cd $(DOCUMENTSERVER)/npm && \
		npm install && \
		pkg ./node_modules/json $(PKG_TARGET:%=-t %) -o json

ifeq ($(PLATFORM),win)		
	cd $(DOCUMENTSERVER)/npm && \
		pkg ./node_modules/replace -o replace
endif		
	rm -r \
		$(DOCUMENTSERVER)/npm/node_modules \
		$(DOCUMENTSERVER)/npm/package-lock.json

	echo "Done" > $@

documentserver-example:
	mkdir -p $(DOCUMENTSERVER_EXAMPLE)
	cp -rf -t $(DOCUMENTSERVER_EXAMPLE) ../build_tools/out/$(TARGET)/$(COMPANY_NAME_LOW)/$(PRODUCT_SHORT_NAME_LOW)-example/* common/documentserver-example/welcome
	
	mkdir -p $(DOCUMENTSERVER_EXAMPLE_CONFIG)

	mv -f $(DOCUMENTSERVER_EXAMPLE)/config/*.json $(DOCUMENTSERVER_EXAMPLE_CONFIG)

	# Prevent for modification original config
	chmod ug=r $(DOCUMENTSERVER_EXAMPLE_CONFIG)/*.json

	sed "s|{{OFFICIAL_PRODUCT_NAME}}|"$(OFFICIAL_PRODUCT_NAME)"|"  -i $(DOCUMENTSERVER_EXAMPLE)/welcome/*.html

	/usr/bin/find $(DOCUMENTSERVER_EXAMPLE)/welcome -depth -type f -exec sed -i "s_{{year}}_$(shell date +"%Y")_g" {} \;

	echo "Done" > $@

apt-rpm/$(PACKAGE_NAME).spec : apt-rpm/package.spec
	mv -f $< $@

$(APT_RPM): $(COMMON_DEPS) $(LINUX_DEPS) documentserver documentserver-example
	mkdir -p $(@D)
	cd $(@D)/../../.. && rpmbuild \
		-bb \
		--define '_topdir $(@D)/../../../builddir' \
		--define '_package_name $(PACKAGE_NAME)' \
		--define '_product_version $(PRODUCT_VERSION)' \
		--define '_build_number $(BUILD_NUMBER)$(APT_RPM_RELEASE_SUFFIX)' \
		--define '_company_name $(COMPANY_NAME)' \
		--define '_product_name $(PRODUCT_NAME)' \
		--define '_publisher_name $(PUBLISHER_NAME)' \
		--define '_publisher_url $(PUBLISHER_URL)' \
		--define '_support_url $(SUPPORT_URL)' \
		--define '_support_mail $(SUPPORT_MAIL)' \
		--define '_company_name_low $(COMPANY_NAME_LOW)' \
		--define '_product_name_low $(PRODUCT_NAME_LOW)' \
		--define '_ds_prefix $(DS_PREFIX)' \
		--define '_binary_payload w7.xzdio' \
		--target $(RPM_ARCH) \
		$(PACKAGE_NAME).spec

rpm/$(PACKAGE_NAME).spec : rpm/package.spec
	mv -f $< $@

$(RPM): $(COMMON_DEPS) $(LINUX_DEPS) documentserver documentserver-example
	mkdir -p $(@D)
	cd $(@D)/../../.. && rpmbuild \
		-bb \
		--define '_topdir $(@D)/../../../builddir' \
		--define '_package_name $(PACKAGE_NAME)' \
		--define '_product_version $(PRODUCT_VERSION)' \
		--define '_build_number $(BUILD_NUMBER)$(RPM_RELEASE_SUFFIX)' \
		--define '_company_name $(COMPANY_NAME)' \
		--define '_product_name $(PRODUCT_NAME)' \
		--define '_publisher_name $(PUBLISHER_NAME)' \
		--define '_publisher_url $(PUBLISHER_URL)' \
		--define '_support_url $(SUPPORT_URL)' \
		--define '_support_mail $(SUPPORT_MAIL)' \
		--define '_company_name_low $(COMPANY_NAME_LOW)' \
		--define '_product_name_low $(PRODUCT_NAME_LOW)' \
		--define '_ds_prefix $(DS_PREFIX)' \
		--define '_binary_payload w7.xzdio' \
		--target $(RPM_ARCH) \
		$(PACKAGE_NAME).spec

ifeq ($(COMPANY_NAME_LOW),onlyoffice)
M4_PARAMS += -D M4_DS_EXAMPLE_ENABLE=1
M4_PARAMS += -D M4_DS_PLUGIN_INSTALLATION=true
else
M4_PARAMS += -D M4_DS_PLUGIN_INSTALLATION=false
endif

ifneq ($(PLUGIN_MANAGER_FILE),)
%.sh : %.sh.m4
	m4 -I"$(BRANDING_DIR)" $(M4_PARAMS) $< > $@
	chmod u+x $@
else ifeq ($(strip $(PLUGIN_MANAGER_FILE)),)
%.sh : %.sh.m4
	m4 -I"$(BRANDING_DIR)" $(M4_PARAMS) $< > $@
	chmod u+x $@
endif

% : %.m4
	m4 -I"$(BRANDING_DIR)" $(M4_PARAMS) $< > $@

% : %.tmpl
	cp $< $@

common/documentserver/nginx/ds.conf: common/documentserver/nginx/ds.conf.tmpl

deb/build/debian/% : deb/template/%
	mkdir -pv $(@D) && cp -fv $< $@

deb/build/debian/% : deb/template/%.m4
	mkdir -pv $(@D) && m4 -I"$(BRANDING_DIR)" $(M4_PARAMS) -D M4_PACKAGE_VERSION=$(PACKAGE_VERSION)$(DEB_RELEASE_SUFFIX) $< > $@

deb/build/debian/$(PACKAGE_NAME).% : deb/template/package.%.m4
	mkdir -pv $(@D) && m4 -I"$(BRANDING_DIR)" $(M4_PARAMS) $< > $@

$(DEB): $(DEB_DEPS) $(COMMON_DEPS) $(LINUX_DEPS) documentserver documentserver-example
	cd deb/build && dpkg-buildpackage -b -uc -us -a$(DEB_ARCH)

%.exe:
	cd $(@D) && $(ISCC) $(ISCC_PARAMS) $(iss_file)

$(EXE): iss_file = common.iss
$(EXE): $(COMMON_DEPS) documentserver documentserver-example $(NGINX) $(PSQL) $(WINSW)

$(EXE_PR): iss_file = prerequisites.iss
$(EXE_PR): $(EXE_PR_DEPS)

$(TAR):
	cd ../build_tools/out/$(TARGET)/$(COMPANY_NAME_LOW) && \
	tar -czf $(TAR) $(PRODUCT_SHORT_NAME_LOW)-snap

$(NGINX):
	$(CURL) $(NGINX_ZIP) http://nginx.org/download/$(NGINX_ZIP) && \
	7z x -y -o$(DOCUMENTSERVER) $(NGINX_ZIP) && \
	mv -f $(DOCUMENTSERVER)/$(NGINX_VER)/ $(NGINX)
	rm -f $(NGINX_ZIP)
	
$(DS_MIME_TYPES):
	$(TOUCH) $(DS_MIME_TYPES) && \
	$(CURL) $(DS_MIME_TYPES) https://raw.githubusercontent.com/nginx/nginx/master/conf/mime.types

$(PSQL):
	$(CURL) $(PSQL_ZIP) http://get.enterprisedb.com/postgresql/$(PSQL_ZIP) && \
	7z x -y -o. $(PSQL_ZIP) && \
	mkdir -p $(PSQL) && \
	cp -rf -t $(PSQL)  pgsql/bin/psql.exe  pgsql/bin/*.dll && \
	rm -f $(PSQL_ZIP) && \
	rm -rf pgsql
	
$(DS_BIN): documentserver

%$(ARCH_EXT):
	mkdir -p $(@D)
	$(AR) $@ ./$(DOCUMENTSERVER)/sdkjs ./$(DOCUMENTSERVER)/server/FileConverter/bin

$(WINSW)      : url = https://github.com/winsw/winsw/releases/download/v3.0.0-alpha.11/WinSW-x64.exe
$(CERTBOT)    : url = https://github.com/certbot/certbot/releases/download/v2.6.0/certbot-beta-installer-win_amd64_signed.exe
$(ERLANG)     : url = https://github.com/erlang/otp/releases/download/OTP-26.2.1/otp_win64_26.2.1.exe
$(OPENSSL)    : url = https://download.firedaemon.com/FireDaemon-OpenSSL/FireDaemon-OpenSSL-x64-3.3.0.exe
$(POSTGRESQL) : url = https://get.enterprisedb.com/postgresql/postgresql-12.17-1-windows-x64.exe
$(PYTHON)     : url = https://www.python.org/ftp/python/3.11.3/python-3.11.3-amd64.exe
$(RABBITMQ)   : url = https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.12.11/rabbitmq-server-3.12.11.exe
$(REDIS)      : url = https://download.onlyoffice.com/install/windows/redist/Redis-x64-5.0.10.msi
$(VC2013)     : url = https://download.visualstudio.microsoft.com/download/pr/10912041/cee5d6bca2ddbcd039da727bf4acb48a/vcredist_x64.exe
$(VC2022)     : url = https://aka.ms/vs/17/release/vc_redist.x64.exe

$(WINSW) $(EXE_PR_DEPS):
	mkdir -p $(@D) && $(CURL) $@ $(url)

packages: $(PACKAGES)

deploy-bin: $(DS_BIN)
	mkdir -p $(DS_BIN_REPO)
	cp -rv $(dir $(DS_BIN)) $(DS_BIN_REPO)
	aws s3 sync --no-progress --acl public-read \
		$(DS_BIN_REPO) \
		s3://$(S3_BUCKET)/$(PLATFORM)/ds-bin/$(GIT_BRANCH)/$(PRODUCT_VERSION)/
