PWD := $(shell pwd)
CURL := curl -L -o
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

BRANDING_DIR ?= ./branding

PACKAGE_NAME := $(COMPANY_NAME_LOW)-$(PRODUCT_NAME_LOW)
PACKAGE_VERSION := $(PRODUCT_VERSION)-$(BUILD_NUMBER)

RPM_ARCH = x86_64
DEB_ARCH = amd64

APT_RPM_BUILD_DIR = $(PWD)/apt-rpm/builddir
RPM_BUILD_DIR = $(PWD)/rpm/builddir
DEB_BUILD_DIR = deb
EXE_BUILD_DIR = exe

APT_RPM_PACKAGE_DIR = $(APT_RPM_BUILD_DIR)/RPMS/$(RPM_ARCH)
RPM_PACKAGE_DIR = $(RPM_BUILD_DIR)/RPMS/$(RPM_ARCH)
DEB_PACKAGE_DIR = $(DEB_BUILD_DIR)
TAR_PACKAGE_DIR = $(PWD)

APT_RPM = $(APT_RPM_PACKAGE_DIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION).$(RPM_ARCH).rpm
RPM = $(RPM_PACKAGE_DIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION).$(RPM_ARCH).rpm
DEB = $(DEB_PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)_$(DEB_ARCH).deb
EXE = $(EXE_BUILD_DIR)/$(PACKAGE_NAME)-$(PRODUCT_VERSION).$(BUILD_NUMBER).exe
TAR = $(TAR_PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION).tar.gz

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

ISXDL = $(EXE_BUILD_DIR)/scripts/isxdl/isxdl.dll

NGINX_VER := nginx-1.21.3
NGINX_ZIP := $(NGINX_VER).zip
NGINX := $(DOCUMENTSERVER)/nginx

DS_MIME_TYPES = common/documentserver/nginx/includes/ds-mime.types.conf

PSQL := $(DOCUMENTSERVER)/pgsql/bin
PSQL_ZIP := postgresql-10.18-1-windows-x64-binaries.zip

NSSM_ZIP := nssm_x64.zip
NSSM := $(DOCUMENTSERVER)/nssm/nssm.exe

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
	UNAME_P := $(shell uname -p)
	ifeq ($(UNAME_P),x86_64)
		ARCHITECTURE := 64
	endif
	ifneq ($(filter %86,$(UNAME_P)),)
		ARCHITECTURE := 32
	endif
endif

TARGET := $(PLATFORM)_$(ARCHITECTURE)
DS_BIN_REPO := ./ds-repo
DS_BIN := ./$(TARGET)/ds-bin-$(PRODUCT_VERSION)$(ARCH_EXT)

ifeq ($(PRODUCT_NAME),$(filter $(PRODUCT_NAME),documentserver-ee documentserver-ie))
PACKAGES += deploy-bin
endif

ISCC := iscc
ISCC_PARAMS +=	//Qp
ISCC_PARAMS +=	//DsAppVerShort=$(PRODUCT_VERSION)
ISCC_PARAMS +=	//DsAppBuildNumber=$(BUILD_NUMBER)
ifdef ENABLE_SIGNING
ISCC_PARAMS +=	//DENABLE_SIGNING=1
endif
ISCC_PARAMS +=	//S"byparam=signtool.exe sign /v /n $(firstword $(PUBLISHER_NAME)) /t http://timestamp.digicert.com \$$f"

DEB_DEPS += deb/debian/changelog
DEB_DEPS += deb/debian/config
DEB_DEPS += deb/debian/control
DEB_DEPS += deb/debian/copyright
DEB_DEPS += deb/debian/postinst
DEB_DEPS += deb/debian/postrm
DEB_DEPS += deb/debian/templates
DEB_DEPS += deb/debian/$(PACKAGE_NAME).install
DEB_DEPS += deb/debian/$(PACKAGE_NAME).links

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

LINUX_DEPS += common/documentserver/supervisor/ds.conf
LINUX_DEPS += common/documentserver/supervisor/ds-converter.conf
LINUX_DEPS += common/documentserver/supervisor/ds-docservice.conf
LINUX_DEPS += common/documentserver/supervisor/ds-metrics.conf

LINUX_DEPS_CLEAN += common/documentserver/supervisor/*.conf

LINUX_DEPS += common/documentserver-example/supervisor/ds.conf
LINUX_DEPS += common/documentserver-example/supervisor/ds-example.conf

LINUX_DEPS_CLEAN += common/documentserver-example/supervisor/*.conf

LINUX_DEPS += $(basename $(wildcard common/documentserver/bin/*.sh.m4))

LINUX_DEPS_CLEAN += common/documentserver/bin/*.sh

LINUX_DEPS += rpm/$(PACKAGE_NAME).spec
LINUX_DEPS += apt-rpm/$(PACKAGE_NAME).spec

LINUX_DEPS_CLEAN += rpm/$(PACKAGE_NAME).spec
LINUX_DEPS_CLEAN += apt-rpm/$(PACKAGE_NAME).spec

LINUX_DEPS += rpm/bin/documentserver-configure.sh
LINUX_DEPS += apt-rpm/bin/documentserver-configure.sh

LINUX_DEPS_CLEAN += rpm/bin/*.sh
LINUX_DEPS_CLEAN += apt-rpm/bin/*.sh

WIN_DEPS += exe/$(PACKAGE_NAME).iss

ifeq ($(COMPANY_NAME_LOW),onlyoffice)
ONLYOFFICE_VALUE := onlyoffice
else
ONLYOFFICE_VALUE := ds
endif

M4_PARAMS += -D M4_COMPANY_NAME=$(COMPANY_NAME)
M4_PARAMS += -D M4_PACKAGE_NAME=$(PACKAGE_NAME)
M4_PARAMS += -D M4_PRODUCT_NAME=$(PRODUCT_NAME)
M4_PARAMS += -D M4_PACKAGE_VERSION=$(PACKAGE_VERSION)
M4_PARAMS += -D M4_PUBLISHER_NAME='$(PUBLISHER_NAME)'
M4_PARAMS += -D M4_PUBLISHER_URL='$(PUBLISHER_URL)'
M4_PARAMS += -D M4_SUPPORT_MAIL='$(SUPPORT_MAIL)'
M4_PARAMS += -D M4_SUPPORT_URL='$(SUPPORT_URL)'
M4_PARAMS += -D M4_BRANDING_DIR='$(abspath $(BRANDING_DIR))'
M4_PARAMS += -D M4_ONLYOFFICE_VALUE=$(ONLYOFFICE_VALUE)
M4_PARAMS += -D M4_PLATFORM=$(PLATFORM)
M4_PARAMS += -D M4_NGINX_CONF='$(NGINX_CONF)'
M4_PARAMS += -D M4_NGINX_LOG='$(NGINX_LOG)'
M4_PARAMS += -D M4_DS_PREFIX='$(DS_PREFIX)'
M4_PARAMS += -D M4_DS_ROOT='$(DS_ROOT)'
M4_PARAMS += -D M4_DS_FILES='$(DS_FILES)'
M4_PARAMS += -D M4_DS_EXAMLE='$(DS_EXAMLE)'
M4_PARAMS += -D M4_DEV_NULL='$(DEV_NULL)'

.PHONY: all clean clean-docker rpm deb packages deploy-bin

all: rpm deb apt-rpm

apt-rpm:$(APT_RPM)

rpm: $(RPM)

deb: $(DEB)

exe: $(EXE)

tar: $(TAR)

clean:
	rm -rf $(DEB_PACKAGE_DIR)/*.deb\
		$(DEB_PACKAGE_DIR)/../*.changes\
		$(APT_RPM_BUILD_DIR)\
		$(RPM_BUILD_DIR)\
		$(TAR_PACKAGE_DIR)/*.tar.gz\
		$(EXE_BUILD_DIR)/*.exe\
		$(ISXDL)\
		$(NGINX)\
		$(NSSM)\
		$(PSQL)\
		$(DS_BIN_REPO)\
		$(DOCUMENTSERVER_FILES)\
		$(DOCUMENTSERVER_EXAMPLE)\
		$(DS_BIN)\
		$(FONTS)\
		$(DEB_DEPS)\
		$(COMMON_DEPS)\
		$(LINUX_DEPS_CLEAN)\
		$(WIN_DEPS)\
		deb/debian/$(PACKAGE_NAME)\
		deb/debian/$(PACKAGE_NAME).*\
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

	[ -f $(LICENSE_FILE) ] && cp -fr -t $(DOCUMENTSERVER) $(LICENSE_FILE) || true

	chmod u+x $(DOCUMENTSERVER)/server/FileConverter/bin/x2t$(EXEC_EXT)
	#chmod u+x $(DOCUMENTSERVER)/server/FileConverter/bin/docbuilder$(EXEC_EXT)
	[ -f $(HTMLFILEINTERNAL)$(EXEC_EXT) ] && chmod u+x $(HTMLFILEINTERNAL)$(EXEC_EXT) || true
	chmod u+x $(DOCUMENTSERVER)/server/tools/allfontsgen$(EXEC_EXT)

	sed "s|\(_dc=\)0|\1"$(PACKAGE_VERSION)"|"  -i $(DOCUMENTSERVER)/web-apps/apps/api/documents/api.js

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
		pkg ./node_modules/json -o json

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

	echo "Done" > $@

$(APT_RPM): $(COMMON_DEPS) $(LINUX_DEPS) documentserver documentserver-example
$(RPM): $(COMMON_DEPS) $(LINUX_DEPS) documentserver documentserver-example

apt-rpm/$(PACKAGE_NAME).spec : apt-rpm/package.spec
	mv -f $< $@

rpm/$(PACKAGE_NAME).spec : rpm/package.spec
	mv -f $< $@

exe/$(PACKAGE_NAME).iss : exe/package.iss
	mv -f $< $@

%.rpm: 
	mkdir -p $(@D)

	cd $(@D)/../../.. && rpmbuild \
		-bb \
		--define '_topdir $(@D)/../../../builddir' \
		--define '_package_name $(PACKAGE_NAME)' \
		--define '_product_version $(PRODUCT_VERSION)' \
		--define '_build_number $(BUILD_NUMBER)' \
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
		$(PACKAGE_NAME).spec

ifeq ($(COMPANY_NAME_LOW),onlyoffice)
M4_PARAMS += -D M4_DS_EXAMPLE_ENABLE=1
endif

%.sh : %.sh.m4
	m4 -I"$(BRANDING_DIR)" $(M4_PARAMS) $< > $@
	chmod u+x $@

% : %.m4
	m4 -I"$(BRANDING_DIR)" $(M4_PARAMS) $< > $@

% : %.tmpl
	cp $< $@

common/documentserver/nginx/ds.conf: common/documentserver/nginx/ds.conf.tmpl

deb/debian/$(PACKAGE_NAME).install : deb/debian/package.install
	mv -f $< $@

deb/debian/$(PACKAGE_NAME).links : deb/debian/package.links
	mv -f $< $@

%.exe:
	cd $(@D) && $(ISCC) $(ISCC_PARAMS) $(PACKAGE_NAME).iss

$(DEB): $(DEB_DEPS) $(COMMON_DEPS) $(LINUX_DEPS) documentserver documentserver-example
	cd deb && dpkg-buildpackage -b -uc -us --changes-option=-u.

$(EXE): $(WIN_DEPS) $(COMMON_DEPS) documentserver documentserver-example $(ISXDL) $(NGINX) $(PSQL) $(NSSM)

$(TAR):
	cd ../build_tools/out/$(TARGET)/$(COMPANY_NAME_LOW) && \
	tar -czf $(TAR) $(PRODUCT_SHORT_NAME_LOW)-snap

$(ISXDL):
	$(TOUCH) $(ISXDL) && \
	$(CURL) $(ISXDL) https://raw.githubusercontent.com/jrsoftware/ispack/is-5_6_1/isxdlfiles/isxdl.dll
	
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

$(NSSM):
	$(CURL) $(NSSM_ZIP) https://github.com/ONLYOFFICE/nssm/releases/download/v2.24.1/$(NSSM_ZIP) && \
	7z x -y -o$(DOCUMENTSERVER)/nssm $(NSSM_ZIP) && \
	rm -f $(NSSM_ZIP)

packages: $(PACKAGES)

deploy-bin: $(DS_BIN)
	mkdir -p $(DS_BIN_REPO)
	cp -rv $(dir $(DS_BIN)) $(DS_BIN_REPO)
	aws s3 sync --no-progress --acl public-read \
		$(DS_BIN_REPO) \
		s3://$(S3_BUCKET)/$(PLATFORM)/ds-bin/$(GIT_BRANCH)/$(PRODUCT_VERSION)/
