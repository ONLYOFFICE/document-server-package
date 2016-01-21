#NODE_MODULES_DIR = node_modules
#NODE_PROJECTS = sources
#NODE_PROJECTS_MODULES = $(addsuffix /$(NODE_MODULES_DIR), $(NODE_PROJECTS))
COMPANY_NAME = onlyoffice
PRODUCT_NAME = documentserver-enterprise
PACKAGE_NAME = $(COMPANY_NAME)-$(PRODUCT_NAME)
PRODUCT_VERSION = 3.6.0
PACKAGE_VERSION = $(PRODUCT_VERSION)-$(BUILD_NUMBER)
#DOCKER_IMAGE_NAME = $(COMPANY_NAME)/$(PRODUCT_NAME):$(PACKAGE_VERSION)
DOCKER_IMAGE_NAME = $(COMPANY_NAME)/4testing-documentserver-enterp:$(PACKAGE_VERSION)
DOCKER_IMAGE_NAME_LATEST = $(COMPANY_NAME)/4testing-documentserver-enterp:$(PACKAGE_VERSION)

RPM_ARCH = x86_64
DEB_ARCH = amd64

RPM_BUILD_DIR = $(PWD)/rpm/builddir
DEB_BUILD_DIR = $(PWD)/deb

RPM_PACKAGE_DIR = $(RPM_BUILD_DIR)/RPMS/$(RPM_ARCH)
DEB_PACKAGE_DIR = $(DEB_BUILD_DIR)

REPO = $(PWD)/repo

RPM_REPO_OS_NAME = centos
RPM_REPO_OS_VER = 7
RPM_REPO_DIR = $(RPM_REPO_OS_NAME)/$(RPM_REPO_OS_VER)

DEB_REPO_OS_NAME = ubuntu
DEB_REPO_OS_VER = trusty
DEB_REPO_DIR = $(DEB_REPO_OS_NAME)/$(DEB_REPO_OS_VER)

RPM = $(RPM_PACKAGE_DIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION).$(RPM_ARCH).rpm
DEB = $(DEB_PACKAGE_DIR)/$(PACKAGE_NAME)_$(PACKAGE_VERSION)_$(DEB_ARCH).deb

DOCUMENTSERVER = common/documentserver

ifeq ($(PACKAGE_NAME), onlyoffice-documentserver-enterprise)
DOCKERHUB_TRIGGER=https://registry.hub.docker.com/u/onlyoffice/4testing-documentserver-enterp/trigger/bd95e307-6a3f-4082-997e-6cc319157fc8/
else
DOCKERHUB_TRIGGER=https://registry.hub.docker.com/u/onlyoffice/4testing-documentserver/trigger/3a3e2739-74ac-4acc-ac82-9dcad3be67d7/
endif

.PHONY: all clean rpm deb clean-repo deploy deploy-rpm deploy-deb documentserver rpm-version deb-version docker docker-image docker-push

all: rpm deb

rpm: documentserver rpm-version $(RPM)

deb: documentserver deb-version $(DEB)

$(NODE_PROJECTS_MODULES):
	cd $(@D) && \
		npm install

clean:
	rm -rf node_modules

documentserver:
	cp -rf ../deploy/deploy/* $(DOCUMENTSERVER)/
	cp -rf ../dev_tools/OnlineEditorsExample/OnlineEditorsExampleNodeJS/ $(DOCUMENTSERVER)/example

	bomstrip-files $(DOCUMENTSERVER)/NodeJsProjects/Common/config/*.json
	rm -f $(DOCUMENTSERVER)/NodeJsProjects/Common/config/*.bom
	mkdir -p common/config/
	mv $(DOCUMENTSERVER)/NodeJsProjects/Common/config/*.json common/config/

	chmod u+x $(DOCUMENTSERVER)/NodeJsProjects/FileConverter/Bin/x2t
	chmod u+x $(DOCUMENTSERVER)/NodeJsProjects/FileConverter/Bin/HtmlFileInternal/HtmlFileInternal
	chmod u+x $(DOCUMENTSERVER)/Tools/AllFontsGen

	sed 's/{{DATE}}/'$$(date +%F-%H-%M)'/'  -i common/nginx/includes/onlyoffice-documentserver-docservice.conf
	sed 's/_dc=0/_dc='$$(date +%F-%H-%M)'/'  -i $(DOCUMENTSERVER)/OfficeWeb/apps/api/documents/api.js

	sed 's/https:\/\/doc\.onlyoffice\.com/'http:\\/\\/localhost'/'  -i $(DOCUMENTSERVER)/example/config.js
	sed 's/http:\/\/localhost\/OfficeWeb/'\\/OfficeWeb'/'  -i $(DOCUMENTSERVER)/example/config.js
	sed 's/config\.haveExternalIp[[:space:]]=[[:space:]]false/'config\.haveExternalIp\ =\ true'/'  -i $(DOCUMENTSERVER)/example/config.js
	sed 's/config\.maxFileSize[[:space:]]=[[:space:]]5242880/'config\.maxFileSize\ =\ 104857600'/'  -i $(DOCUMENTSERVER)/example/config.js

rpm-version:
	chmod u+x rpm/Files/onlyoffice/configure.sh

	sed 's/{{PRODUCT_VERSION}}/'$(PRODUCT_VERSION)'/'  -i rpm/$(PACKAGE_NAME).spec
	sed 's/{{BUILD_NUMBER}}/'${BUILD_NUMBER}'/'  -i rpm/$(PACKAGE_NAME).spec

deb-version:
	sed 's/{{PACKAGE_VERSION}}/'$(PACKAGE_VERSION)'/'  -i deb/$(PACKAGE_NAME)/debian/changelog

$(RPM):
	ls -l $(RPM) || echo "Rpm file not exist"
	cd rpm && rpmbuild -bb --define "_topdir $(RPM_BUILD_DIR)" $(PACKAGE_NAME).spec

$(DEB):
	ls -l $(DEB) || echo "Deb file not exist"
	cd deb/$(PACKAGE_NAME) && dpkg-buildpackage -b -uc -us

deploy-rpm: $(RPM)
	rm -rfv $(REPO)
	mkdir -p $(REPO)

	cp -rv $(RPM) $(REPO);
	createrepo -v $(REPO);

	aws s3 sync $(REPO) s3://repo-doc-onlyoffice-com/$(RPM_REPO_DIR)/$(PACKAGE_NAME)/$(SVN_TAG)/ --acl public-read --delete

ifeq ($(SVN_TAG), trunk)
	aws s3 sync $(REPO) s3://repo-doc-onlyoffice-com/archive/$(RPM_REPO_DIR)/$(PACKAGE_NAME)/$(PACKAGE_VERSION)/ --acl public-read --delete
endif

deploy-deb: $(DEB)
	rm -rfv $(REPO)
	mkdir -p $(REPO)

	cp -rv $(DEB) $(REPO);
	dpkg-scanpackages -m repo /dev/null | gzip -9c > $(REPO)/Packages.gz

	aws s3 sync $(REPO) s3://repo-doc-onlyoffice-com/$(DEB_REPO_DIR)/$(PACKAGE_NAME)/$(SVN_TAG)/repo --acl public-read --delete

ifeq ($(SVN_TAG), trunk)
	aws s3 sync $(REPO) s3://repo-doc-onlyoffice-com/archive/$(DEB_REPO_DIR)/$(PACKAGE_NAME)/$(PACKAGE_VERSION)/repo --acl public-read --delete
endif

deploy: deploy-rpm deploy-deb

docker:
ifeq ($(SVN_TAG), trunk)
	curl -H "Content-Type: application/json" --data '{"build": true}' -X POST $(DOCKERHUB_TRIGGER)
endif

docker-image: docker-push
	cd docker/$(PACKAGE_NAME)
	sudo docker build -t $(DOCKER_IMAGE_NAME) .
	sudo docker build -t $(DOCKER_IMAGE_NAME_LATEST) .

docker-push:
	sudo docker push $(DOCKER_IMAGE_NAME)
	sudo docker push $(DOCKER_IMAGE_NAME_LATEST)