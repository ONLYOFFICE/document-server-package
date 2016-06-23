PACKAGE_NAME := $(COMPANY_NAME)-$(PRODUCT_NAME)
PACKAGE_VERSION := $(PRODUCT_VERSION)-$(BUILD_NUMBER)

ifeq ($(GIT_BRANCH), origin/develop)
DOCKER_TAGS += $(PACKAGE_VERSION)
DOCKER_TAGS += latest
else
DOCKER_TAGS += $(PACKAGE_VERSION)-$(subst /,-,$(GIT_BRANCH))
endif

DOCKER_REPO = $(COMPANY_NAME)/4testing-$(PRODUCT_NAME)

COLON := __colon__
DOCKER_TARGETS := $(foreach TAG,$(DOCKER_TAGS),$(DOCKER_REPO)$(COLON)$(TAG))

RPM_ARCH = x86_64
DEB_ARCH = amd64

RPM_BUILD_DIR = $(PWD)/rpm/builddir
DEB_BUILD_DIR = $(PWD)/deb

RPM_PACKAGE_DIR = $(RPM_BUILD_DIR)/RPMS/$(RPM_ARCH)
DEB_PACKAGE_DIR = $(DEB_BUILD_DIR)

DEB_REPO := $(PWD)/repo
DEB_REPO_DATA := $(DEB_REPO)/Packages.gz

RPM_REPO := $(PWD)/repo-rpm
RPM_REPO_DATA := $(RPM_REPO)/repodata

RPM_REPO_OS_NAME = centos
RPM_REPO_OS_VER = 7
RPM_REPO_DIR = $(RPM_REPO_OS_NAME)/$(RPM_REPO_OS_VER)

DEB_REPO_OS_NAME = ubuntu
DEB_REPO_OS_VER = trusty
DEB_REPO_DIR = $(DEB_REPO_OS_NAME)/$(DEB_REPO_OS_VER)

RPM = $(RPM_PACKAGE_DIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION).$(RPM_ARCH).rpm
DEB = $(DEB_PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)_$(DEB_ARCH).deb

DOCUMENTSERVER = common/documentserver/home
DOCUMENTSERVER_BIN = common/documentserver/bin
DOCUMENTSERVER_CONFIG = common/documentserver/config
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/web-apps
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/server
DOCUMENTSERVER_FILES += $(DOCUMENTSERVER)/sdkjs

LICENSE_FILES += $(DOCUMENTSERVER)/server/LICENSE.txt 
LICENSE_FILES += $(DOCUMENTSERVER)/server/3rd-Party.txt 
LICENSE_FILES += $(DOCUMENTSERVER)/server/license

DOCUMENTSERVER_EXAMPLE = common/documentserver-example/home
DOCUMENTSERVER_EXAMPLE_CONFIG = common/documentserver-example/config

FONTS = common/fonts

.PHONY: all clean clean-docker rpm deb deploy deploy-rpm deploy-deb docker docker-version deploy-docker

all: rpm deb

rpm: $(RPM)

deb: $(DEB)

$(DOCKER_TARGETS): $(DEB_REPO_DATA)
	sed "s|{{SVN_TAG}}|$(GIT_BRANCH)|"  -i docker/$(PACKAGE_NAME)/Dockerfile
	sed 's/{{PACKAGE_VERSION}}/'$(PACKAGE_VERSION)'/'  -i docker/$(PACKAGE_NAME)/Dockerfile

	cd docker/$(PACKAGE_NAME) &&\
	sudo docker build -t $(subst $(COLON),:,$@) . &&\
	mkdir -p $$(dirname ../../$@) &&\
	echo "Done" > ../../$@

docker: $(DOCKER_TARGETS)

clean:
	rm -rfv $(DEB_PACKAGE_DIR)/*.deb\
		$(DEB_PACKAGE_DIR)/*.changes\
		$(RPM_BUILD_DIR)\
		$(DEB_REPO)\
		$(RPM_REPO)\
		$(DOCKER_TARGETS)\
		$(DOCUMENTSERVER_FILES)\
		documentserver \
		documentserver-example
		
clean-docker:
	sudo docker rmi -f $$(sudo docker images -q $(COMPANY_NAME)/*) || exit 0

documentserver:
	mkdir -p $(DOCUMENTSERVER_FILES)
	cp -rf ../web-apps/deploy/* $(DOCUMENTSERVER)
	cp -rf ../server/build/* $(DOCUMENTSERVER)/server

	bomstrip-files $(DOCUMENTSERVER)/server/Common/config/*.json
	bomstrip-files $(DOCUMENTSERVER)/server/Common/config/log4js/*.json

	rm -f $(DOCUMENTSERVER)/server/Common/config/*.bom
	rm -f $(DOCUMENTSERVER)/server/Common/config/log4js/*.bom

	mkdir -p $(DOCUMENTSERVER_CONFIG)
	mkdir -p $(DOCUMENTSERVER_CONFIG)/log4js

	mv $(DOCUMENTSERVER)/server/Common/config/*.json $(DOCUMENTSERVER_CONFIG)
	mv $(DOCUMENTSERVER)/server/Common/config/log4js/*.json $(DOCUMENTSERVER_CONFIG)/log4js/
	
	cp -fr -t $(DOCUMENTSERVER) $(LICENSE_FILES)
	rm -fr $(LICENSE_FILES)

	chmod u+x $(DOCUMENTSERVER)/server/FileConverter/bin/x2t
	chmod u+x $(DOCUMENTSERVER)/server/FileConverter/bin/HtmlFileInternal/HtmlFileInternal
	chmod u+x $(DOCUMENTSERVER)/server/tools/AllFontsGen
	chmod u+x $(DOCUMENTSERVER_BIN)/documentserver-prepare4shutdown.sh
	chmod u+x $(DOCUMENTSERVER_BIN)/documentserver-generate-allfonts.sh

	sed 's/{{DATE}}/'$$(date +%F-%H-%M)'/'  -i common/nginx/includes/onlyoffice-documentserver-docservice.conf
	sed 's/_dc=0/_dc='$$(date +%F-%H-%M)'/'  -i $(DOCUMENTSERVER)/web-apps/apps/api/documents/api.js
	
	mkdir -p $(FONTS)/Asana-Math
	wget -O $(FONTS)/Asana-Math/ASANA.TTC http://mirrors.ctan.org/fonts/Asana-Math/ASANA.TTC
	wget -O $(FONTS)/Asana-Math/README http://mirrors.ctan.org/fonts/Asana-Math/README
	
	echo "Done" > $@

documentserver-example:
	mkdir -p $(DOCUMENTSERVER_EXAMPLE)
	cp -rf ../document-server-integration/web/documentserver-example/nodejs/** $(DOCUMENTSERVER_EXAMPLE)
	
	bomstrip-files $(DOCUMENTSERVER_EXAMPLE)/config/*.json

	rm -f $(DOCUMENTSERVER_EXAMPLE)/config/*.bom

	mkdir -p $(DOCUMENTSERVER_EXAMPLE_CONFIG)

	mv $(DOCUMENTSERVER_EXAMPLE)/config/*.json $(DOCUMENTSERVER_EXAMPLE_CONFIG)

	echo "Done" > $@

$(RPM):	documentserver documentserver-example
	chmod u+x rpm/bin/documentserver-configure.sh
	sed 's/{{PRODUCT_VERSION}}/'$(PRODUCT_VERSION)'/'  -i rpm/$(PACKAGE_NAME).spec
	sed 's/{{BUILD_NUMBER}}/'${BUILD_NUMBER}'/'  -i rpm/$(PACKAGE_NAME).spec

	cd rpm && rpmbuild -bb --define "_topdir $(RPM_BUILD_DIR)" $(PACKAGE_NAME).spec

$(DEB): documentserver documentserver-example
	sed 's/{{PACKAGE_VERSION}}/'$(PACKAGE_VERSION)'/'  -i deb/$(PACKAGE_NAME)/debian/changelog

	cd deb/$(PACKAGE_NAME) && dpkg-buildpackage -b -uc -us

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

deploy-docker: $(DOCKER_TARGETS)
	$(foreach TARGET,$(DOCKER_TARGETS),sudo docker push $(subst $(COLON),:,$(TARGET));)

deploy: $(RPM_REPO_DATA) $(DEB_REPO_DATA) deploy-docker
