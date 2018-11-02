PWD := $(shell pwd)
CURL := curl -L -o

COMPANY_NAME ?= ONLYOFFICE
PRODUCT_NAME ?= DocumentServer

COMPANY_NAME_LOW = $(shell echo $(COMPANY_NAME) | tr A-Z a-z)
PRODUCT_NAME_LOW = $(shell echo $(PRODUCT_NAME) | tr A-Z a-z)

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
DEB_BUILD_DIR = $(PWD)
EXE_BUILD_DIR = $(PWD)/exe

APT_RPM_PACKAGE_DIR = $(APT_RPM_BUILD_DIR)/RPMS/$(RPM_ARCH)
RPM_PACKAGE_DIR = $(RPM_BUILD_DIR)/RPMS/$(RPM_ARCH)
DEB_PACKAGE_DIR = $(DEB_BUILD_DIR)

DEB_REPO := $(PWD)/repo
DEB_REPO_DATA := $(DEB_REPO)/Packages.gz

APT_RPM_REPO := $(PWD)/repo-apt-rpm
APT_RPM_REPO_DATA := $(APT_RPM_REPO)/repodata

RPM_REPO := $(PWD)/repo-rpm
RPM_REPO_DATA := $(RPM_REPO)/repodata

EXE_REPO := repo-exe
EXE_REPO_DATA := $(EXE_REPO)/$(PACKAGE_NAME)-$(PRODUCT_VERSION).$(BUILD_NUMBER).exe

APT_RPM_REPO_OS_NAME = ALTLinux
APT_RPM_REPO_OS_VER = p8
APT_RPM_REPO_DIR = $(APT_RPM_REPO_OS_NAME)/$(APT_RPM_REPO_OS_VER)

RPM_REPO_OS_NAME = centos
RPM_REPO_OS_VER = 7
RPM_REPO_DIR = $(RPM_REPO_OS_NAME)/$(RPM_REPO_OS_VER)

DEB_REPO_OS_NAME = ubuntu
DEB_REPO_OS_VER = trusty
DEB_REPO_DIR = $(DEB_REPO_OS_NAME)/$(DEB_REPO_OS_VER)

EXE_REPO_DIR = windows

APT_RPM = $(APT_RPM_PACKAGE_DIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION).$(RPM_ARCH).rpm
RPM = $(RPM_PACKAGE_DIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION).$(RPM_ARCH).rpm
DEB = $(DEB_PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)_$(DEB_ARCH).deb
EXE = $(EXE_BUILD_DIR)/$(PACKAGE_NAME)-$(PRODUCT_VERSION).$(BUILD_NUMBER).exe

SDKJS_PLUGINS := sdkjs-plugins

DOCUMENTSERVER = common/documentserver/home
DOCUMENTSERVER_BIN = common/documentserver/bin
DOCUMENTSERVER_CONFIG = common/documentserver/config
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/web-apps
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/server
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/sdkjs
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/$(SDKJS_PLUGINS)
LICENSE_JS = $(DOCUMENTSERVER)/server/Common/sources/license.js

3RD_PARTY_LICENSE_FILES += $(DOCUMENTSERVER)/server/LICENSE.txt 
3RD_PARTY_LICENSE_FILES += $(DOCUMENTSERVER)/server/3rd-Party.txt 
3RD_PARTY_LICENSE_FILES += $(DOCUMENTSERVER)/server/license

LICENSE_FILE = $(BRANDING_DIR)/common/documentserver/license/$(PACKAGE_NAME)/LICENSE.txt
HTMLFILEINTERNAL = $(DOCUMENTSERVER)/server/FileConverter/bin/HtmlFileInternal/HtmlFileInternal

DOCUMENTSERVER_EXAMPLE = common/documentserver-example/home
DOCUMENTSERVER_EXAMPLE_CONFIG = common/documentserver-example/config

DOCUMENTSERVER_PLUGINS += ../$(SDKJS_PLUGINS)/cl?part
DOCUMENTSERVER_PLUGINS += ../$(SDKJS_PLUGINS)/m?cros
DOCUMENTSERVER_PLUGINS += ../$(SDKJS_PLUGINS)/oc?
DOCUMENTSERVER_PLUGINS += ../$(SDKJS_PLUGINS)/ph?toeditor
DOCUMENTSERVER_PLUGINS += ../$(SDKJS_PLUGINS)/sp?ech
DOCUMENTSERVER_PLUGINS += ../$(SDKJS_PLUGINS)/s?mboltable
DOCUMENTSERVER_PLUGINS += ../$(SDKJS_PLUGINS)/tr?nslate
DOCUMENTSERVER_PLUGINS += ../$(SDKJS_PLUGINS)/y?utube
DOCUMENTSERVER_PLUGINS += ../$(SDKJS_PLUGINS)/pluginBase.js
DOCUMENTSERVER_PLUGINS += ../$(SDKJS_PLUGINS)/plugins.css

FONTS = common/fonts

ISXDL = $(EXE_BUILD_DIR)/scripts/isxdl/isxdl.dll

NGINX_VER := nginx-1.11.4
NGINX_ZIP := $(NGINX_VER).zip
NGINX := $(DOCUMENTSERVER)/nginx

PSQL := $(DOCUMENTSERVER)/pgsql/bin/psql.exe
PSQL_ZIP := postgresql-9.5.4-2-windows-x64-binaries.zip

NSSM_ZIP := nssm_x64.zip
NSSM := $(DOCUMENTSERVER)/nssm/nssm.exe

BUILD_DATE := $(shell date +%F-%H-%M)

WEBAPPS_DIR ?= web-apps

ifeq ($(PRODUCT_NAME_LOW),$(filter $(PRODUCT_NAME_LOW),documentserver-de documentserver-ie))
WEBAPPS_DIR ?= web-apps-pro
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
	DEPLOY := $(EXE_REPO_DATA)
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
		DEPLOY := $(APT_RPM_REPO_DATA) $(RPM_REPO_DATA) $(DEB_REPO_DATA)
		DS_PREFIX := $(COMPANY_NAME_LOW)/$(PRODUCT_NAME_LOW)
		NGINX_CONF := /etc/nginx/includes
		NGINX_LOG := /var/log/$(DS_PREFIX)
		DS_ROOT := /var/www/$(DS_PREFIX)
		DS_FILES := /var/lib/$(DS_PREFIX)
		DS_EXAMLE := /var/www/$(DS_PREFIX)-example
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

DEB_DEPS += deb/debian/changelog
DEB_DEPS += deb/debian/control
DEB_DEPS += deb/debian/copyright
DEB_DEPS += deb/debian/postinst
DEB_DEPS += deb/debian/postrm
DEB_DEPS += deb/debian/$(PACKAGE_NAME).install
DEB_DEPS += deb/debian/$(PACKAGE_NAME).links

COMMON_DEPS += common/documentserver/nginx/includes/ds-common.conf
COMMON_DEPS += common/documentserver/nginx/includes/ds-docservice.conf
COMMON_DEPS += common/documentserver/nginx/includes/ds-spellchecker.conf
COMMON_DEPS += common/documentserver/nginx/includes/http-common.conf
COMMON_DEPS += common/documentserver/nginx/ds-ssl.conf.tmpl
COMMON_DEPS += common/documentserver/nginx/ds.conf.tmpl
COMMON_DEPS += common/documentserver/nginx/ds.conf
COMMON_DEPS += common/documentserver-example/nginx/includes/ds-example.conf

LINUX_DEPS += common/documentserver/logrotate/ds.conf

LINUX_DEPS += common/documentserver/supervisor/ds.conf
LINUX_DEPS += common/documentserver/supervisor/ds-converter.conf
LINUX_DEPS += common/documentserver/supervisor/ds-docservice.conf
LINUX_DEPS += common/documentserver/supervisor/ds-gc.conf
LINUX_DEPS += common/documentserver/supervisor/ds-metrics.conf
LINUX_DEPS += common/documentserver/supervisor/ds-spellchecker.conf
LINUX_DEPS += common/documentserver-example/supervisor/ds.conf
LINUX_DEPS += common/documentserver-example/supervisor/ds-example.conf

LINUX_DEPS += $(basename $(wildcard common/documentserver/bin/*.sh.m4))

LINUX_DEPS += rpm/$(PACKAGE_NAME).spec
LINUX_DEPS += apt-rpm/$(PACKAGE_NAME).spec

LINUX_DEPS += rpm/bin/documentserver-configure.sh
LINUX_DEPS += apt-rpm/bin/documentserver-configure.sh

WIN_DEPS += exe/$(PACKAGE_NAME).iss

M4_PARAMS += -D PACKAGE_NAME=$(PACKAGE_NAME)
M4_PARAMS += -D PRODUCT_NAME=$(PRODUCT_NAME)
M4_PARAMS += -D PACKAGE_VERSION=$(PACKAGE_VERSION)
M4_PARAMS += -D PUBLISHER_NAME="$(PUBLISHER_NAME)"
M4_PARAMS += -D PUBLISHER_URL="$(PUBLISHER_URL)"
M4_PARAMS += -D SUPPORT_MAIL="$(SUPPORT_MAIL)"
M4_PARAMS += -D SUPPORT_URL="$(SUPPORT_URL)"
M4_PARAMS += -D M4_PLATFORM="$(PLATFORM)"
M4_PARAMS += -D M4_NGINX_CONF="$(NGINX_CONF)"
M4_PARAMS += -D M4_NGINX_LOG="$(NGINX_LOG)"
M4_PARAMS += -D M4_DS_PREFIX="$(DS_PREFIX)"
M4_PARAMS += -D M4_DS_ROOT="$(DS_ROOT)"
M4_PARAMS += -D M4_DS_FILES="$(DS_FILES)"
M4_PARAMS += -D M4_DS_EXAMLE="$(DS_EXAMLE)"
M4_PARAMS += -D M4_DEV_NULL="$(DEV_NULL)"

.PHONY: all clean clean-docker rpm deb deploy deploy-rpm deploy-deb

all: rpm deb apt-rpm

apt-rpm:$(APT_RPM)

rpm: $(RPM)

deb: $(DEB)

exe: $(EXE)

clean:
	rm -rfv $(DEB_PACKAGE_DIR)/*.deb\
		$(DEB_PACKAGE_DIR)/*.changes\
		$(APT_RPM_BUILD_DIR)\
		$(RPM_BUILD_DIR)\
		$(EXE_BUILD_DIR)/*.exe\
		$(ISXDL)\
		$(NGINX)\
		$(NSSM)\
		$(DEB_REPO)\
		$(RPM_REPO)\
		$(EXE_REPO)\
		$(DOCUMENTSERVER_FILES)\
		$(DOCUMENTSERVER_EXAMPLE)\
		$(FONTS)\
		$(DEB_DEPS)\
		$(COMMON_DEPS)\
		$(LINUX_DEPS)\
		$(WIN_DEPS)\
		deb/debian/$(PACKAGE_NAME)\
		deb/debian/$(PACKAGE_NAME).*\
		documentserver\
		documentserver-example
		
documentserver:
	mkdir -p $(DOCUMENTSERVER_FILES)
	cp -rf -t $(DOCUMENTSERVER) ../$(WEBAPPS_DIR)/deploy/* ../server/build/* 
	cp -fr -t $(DOCUMENTSERVER)/$(SDKJS_PLUGINS) $(DOCUMENTSERVER_PLUGINS)

	mkdir -p $(DOCUMENTSERVER_CONFIG)
	mkdir -p $(DOCUMENTSERVER_CONFIG)/log4js

	mv -f $(DOCUMENTSERVER)/server/Common/config/*.json $(DOCUMENTSERVER_CONFIG)
	mv -f $(DOCUMENTSERVER)/server/Common/config/log4js/*.json $(DOCUMENTSERVER_CONFIG)/log4js/

	# rename product specific folders
	sed "s|onlyoffice\/documentserver|"$(DS_PREFIX)"|"  -i $(DOCUMENTSERVER_CONFIG)/*.json

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
	chmod u+x $(DOCUMENTSERVER)/server/tools/AllFontsGen$(EXEC_EXT)

	sed "s|\(_dc=\)0|\1"$(PACKAGE_VERSION)"|"  -i $(DOCUMENTSERVER)/web-apps/apps/api/documents/api.js

ifeq ($(PRODUCT_NAME_LOW), documentserver)
	sed "s|\(const oPackageType = \).*|\1constants.PACKAGE_TYPE_OS;|" -i $(LICENSE_JS)
endif

ifeq ($(PRODUCT_NAME_LOW), documentserver-de)
	sed "s|\(const oPackageType = \).*|\1constants.PACKAGE_TYPE_D;|" -i $(LICENSE_JS)
endif

ifeq ($(PRODUCT_NAME_LOW), documentserver-ie)
	sed "s|\(const oPackageType = \).*|\1constants.PACKAGE_TYPE_I;|" -i $(LICENSE_JS)
endif

	echo "Done" > $@

documentserver-example:
	mkdir -p $(DOCUMENTSERVER_EXAMPLE)
	cp -rf -t $(DOCUMENTSERVER_EXAMPLE) ../document-server-integration/web/documentserver-example/nodejs/** common/documentserver-example/welcome
	
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
		--define "_topdir $(@D)/../../../builddir" \
		--define "_package_name $(PACKAGE_NAME)" \
		--define "_product_version $(PRODUCT_VERSION)" \
		--define "_build_number $(BUILD_NUMBER)" \
		--define "_company_name $(COMPANY_NAME)" \
		--define "_product_name $(PRODUCT_NAME)" \
		--define "_publisher_name $(PUBLISHER_NAME)" \
		--define "_publisher_url $(PUBLISHER_URL)" \
		--define "_support_url $(SUPPORT_URL)" \
		--define "_support_mail $(SUPPORT_MAIL)" \
		--define "_company_name_low $(COMPANY_NAME_LOW)" \
		--define "_product_name_low $(PRODUCT_NAME_LOW)" \
		--define "_ds_prefix $(DS_PREFIX)" \
		$(PACKAGE_NAME).spec

ifeq ($(PACKAGE_NAME),$(filter $(PACKAGE_NAME),onlyoffice-documentserver-de onlyoffice-documentserver-ie))
M4_PARAMS += -D M4_DS_EXAMPLE_ENABLE=1
endif

%.sh : %.sh.m4
	m4 $(M4_PARAMS)	$< > $@
	chmod u+x $@

% : %.m4
	m4 $(M4_PARAMS)	$< > $@

% : %.tmpl
	cp $< $@

common/documentserver/nginx/ds.conf: common/documentserver/nginx/ds.conf.tmpl

deb/debian/$(PACKAGE_NAME).install : deb/debian/package.install
	mv -f $< $@

deb/debian/$(PACKAGE_NAME).links : deb/debian/package.links
	mv -f $< $@

%.exe:
	cd $(@D) && iscc \
	//DsCompanyName=$(PRODUCT_VERSION).$(BUILD_NUMBER) \
	//DsAppVersion=$(PRODUCT_VERSION).$(BUILD_NUMBER) \
	//DsCompanyName=$(COMPANY_NAME) \
	//DsPublisherName=$(PUBLISHER_NAME) \
	//DsPublisherUrl=$(PUBLISHER_URL) \
	//Qp \
	//S"byparam=signtool.exe sign /v /s My /n Ascensio /t http://timestamp.verisign.com/scripts/timstamp.dll \$$f" \
	$(PACKAGE_NAME).iss

$(DEB): $(DEB_DEPS) $(COMMON_DEPS) $(LINUX_DEPS) documentserver documentserver-example
	cd deb && dpkg-buildpackage -b -uc -us

$(EXE): $(WIN_DEPS) $(COMMON_DEPS) documentserver documentserver-example $(ISXDL) $(NGINX) $(PSQL) $(NSSM)

$(ISXDL):
	$(CURL) $(ISXDL) https://raw.githubusercontent.com/jrsoftware/ispack/master/isxdlfiles/isxdl.dll
	
$(NGINX):
	$(CURL) $(NGINX_ZIP) http://nginx.org/download/$(NGINX_ZIP) && \
	7z x -y -o$(DOCUMENTSERVER) $(NGINX_ZIP) && \
	mv -f $(DOCUMENTSERVER)/$(NGINX_VER)/ $(NGINX)
	rm -f $(NGINX_ZIP)
	
$(PSQL):
	$(CURL) $(PSQL_ZIP) http://get.enterprisedb.com/postgresql/$(PSQL_ZIP) && \
	7z x -y -o. $(PSQL_ZIP) && \
	mkdir -p $(DOCUMENTSERVER)/pgsql/bin && \
	cp -rf -t $(DOCUMENTSERVER)/pgsql/bin  pgsql/bin/psql.exe  pgsql/bin/*.dll && \
	rm -f $(PSQL_ZIP)
	
$(NSSM):
	$(CURL) $(NSSM_ZIP) https://github.com/ONLYOFFICE/nssm/releases/download/v2.24.1/$(NSSM_ZIP) && \
	7z x -y -o$(DOCUMENTSERVER)/nssm $(NSSM_ZIP) && \
	rm -f $(NSSM_ZIP)

$(RPM_REPO_DATA): $(RPM)
	rm -rfv $(RPM_REPO)
	mkdir -p $(RPM_REPO)

	cp -rv $(RPM) $(RPM_REPO);
	createrepo -v $(RPM_REPO);

	aws s3 sync \
		$(RPM_REPO) \
		s3://repo-doc-onlyoffice-com/$(RPM_REPO_DIR)/$(PACKAGE_NAME)/$(GIT_BRANCH)/$(PACKAGE_VERSION)/ \
		--acl public-read --delete

	aws s3 sync \
		s3://repo-doc-onlyoffice-com/$(RPM_REPO_DIR)/$(PACKAGE_NAME)/$(GIT_BRANCH)/$(PACKAGE_VERSION)/  \
		s3://repo-doc-onlyoffice-com/$(RPM_REPO_DIR)/$(PACKAGE_NAME)/$(GIT_BRANCH)/latest/ \
		--acl public-read --delete

$(APT_RPM_REPO_DATA): $(APT_RPM)
	rm -rfv $(APT_RPM_REPO)
	mkdir -p $(APT_RPM_REPO)

	cp -rv $(APT_RPM) $(APT_RPM_REPO);
	#createrepo -v $(APT_RPM_REPO);

	aws s3 sync \
		$(APT_RPM_REPO) \
		s3://repo-doc-onlyoffice-com/$(APT_RPM_REPO_DIR)/$(PACKAGE_NAME)/$(GIT_BRANCH)/$(PACKAGE_VERSION)/ \
		--acl public-read --delete

	aws s3 sync \
		s3://repo-doc-onlyoffice-com/$(APT_RPM_REPO_DIR)/$(PACKAGE_NAME)/$(GIT_BRANCH)/$(PACKAGE_VERSION)/  \
		s3://repo-doc-onlyoffice-com/$(APT_RPM_REPO_DIR)/$(PACKAGE_NAME)/$(GIT_BRANCH)/latest/ \
		--acl public-read --delete

$(DEB_REPO_DATA): $(DEB)
	rm -rfv $(DEB_REPO)
	mkdir -p $(DEB_REPO)

	cp -rv $(DEB) $(DEB_REPO);
	dpkg-scanpackages -m repo /dev/null | gzip -9c > $(DEB_REPO_DATA)

	aws s3 sync \
		$(DEB_REPO) \
		s3://repo-doc-onlyoffice-com/$(DEB_REPO_DIR)/$(PACKAGE_NAME)/$(GIT_BRANCH)/$(PACKAGE_VERSION)/repo \
		--acl public-read --delete

	aws s3 sync \
		s3://repo-doc-onlyoffice-com/$(DEB_REPO_DIR)/$(PACKAGE_NAME)/$(GIT_BRANCH)/$(PACKAGE_VERSION)/repo \
		s3://repo-doc-onlyoffice-com/$(DEB_REPO_DIR)/$(PACKAGE_NAME)/$(GIT_BRANCH)/latest/repo \
		--acl public-read --delete

$(EXE_REPO_DATA): $(EXE)
	rm -rfv $(EXE_REPO)
	mkdir -p $(EXE_REPO)

	cp -rv $(EXE) $(EXE_REPO);

	aws s3 sync \
		$(EXE_REPO) \
		s3://repo-doc-onlyoffice-com/$(EXE_REPO_DIR)/$(PACKAGE_NAME)/$(GIT_BRANCH)/$(PACKAGE_VERSION)/ \
		--acl public-read --delete

	aws s3 sync \
		s3://repo-doc-onlyoffice-com/$(EXE_REPO_DIR)/$(PACKAGE_NAME)/$(GIT_BRANCH)/$(PACKAGE_VERSION)/  \
		s3://repo-doc-onlyoffice-com/$(EXE_REPO_DIR)/$(PACKAGE_NAME)/$(GIT_BRANCH)/latest/ \
		--acl public-read --delete

deploy: $(DEPLOY)
