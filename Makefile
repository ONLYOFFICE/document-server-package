COMPANY_NAME := onlyoffice
PRODUCT_NAME := documentserver-enterprise
PACKAGE_NAME := $(COMPANY_NAME)-$(PRODUCT_NAME)
PRODUCT_VERSION := 3.6.0
PACKAGE_VERSION := $(PRODUCT_VERSION)-$(BUILD_NUMBER)

ifeq ($(SVN_TAG), trunk)
DOCKER_TAGS += $(PACKAGE_VERSION)
DOCKER_TAGS += latest
else
DOCKER_TAGS += $(PACKAGE_VERSION)-$(subst /,-,$(SVN_TAG))
endif

#DOCKER_REPO = $(COMPANY_NAME)/$(PRODUCT_NAME)
DOCKER_REPO := $(COMPANY_NAME)/4testing-documentserver-enterp
COLON := __colon__
DOCKER_TARGETS := $(foreach TAG,$(DOCKER_TAGS),$(DOCKER_REPO)$(COLON)$(TAG))

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

.PHONY: all clean rpm deb deploy deploy-rpm deploy-deb documentserver rpm-version deb-version docker docker-version deploy-docker

all: deb

rpm: documentserver rpm-version $(RPM)

deb: documentserver deb-version $(DEB)

$(DOCKER_TARGETS): docker-version
	cd docker/$(PACKAGE_NAME) &&\
	sudo docker build -t $(subst $(COLON),:,$@) . &&\
	echo "Done" > ../../$@

docker: $(DOCKER_TARGETS)

clean:
	rm -rfv $(DEB_PACKAGE_DIR)/*.deb\
		$(DEB_PACKAGE_DIR)/*.changes\
		$(RPM_BUILD_DIR)\
		$(REPO)\
		$(DOCKER_TARGETS)
	sudo docker rm $$(sudo docker ps -a -q) || exit 0
	sudo docker rmi -f $$(sudo docker images -q $(COMPANY_NAME)/*) || exit 0

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
  
docker-version:
	sed 's/{{SVN_TAG}}/'$(SVN_TAG)'/'  -i docker/$(PACKAGE_NAME)/Dockerfile
	sed 's/{{PACKAGE_VERSION}}/'$(PACKAGE_VERSION)'/'  -i docker/$(PACKAGE_NAME)/Dockerfile

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

	aws s3 sync $(REPO) s3://repo-doc-onlyoffice-com/$(RPM_REPO_DIR)/$(PACKAGE_NAME)/$(SVN_TAG)/$(PACKAGE_VERSION)/ --acl public-read --delete
	aws s3 sync $(REPO) s3://repo-doc-onlyoffice-com/$(RPM_REPO_DIR)/$(PACKAGE_NAME)/$(SVN_TAG)/latest/ --acl public-read --delete

deploy-deb: $(DEB)
	rm -rfv $(REPO)
	mkdir -p $(REPO)

	cp -rv $(DEB) $(REPO);
	dpkg-scanpackages -m repo /dev/null | gzip -9c > $(REPO)/Packages.gz

	aws s3 sync $(REPO) s3://repo-doc-onlyoffice-com/$(DEB_REPO_DIR)/$(PACKAGE_NAME)/$(SVN_TAG)/$(PACKAGE_VERSION)/repo --acl public-read --delete
	aws s3 sync $(REPO) s3://repo-doc-onlyoffice-com/$(DEB_REPO_DIR)/$(PACKAGE_NAME)/$(SVN_TAG)/latest/repo --acl public-read --delete

deploy-docker: $(DOCKER_TARGETS)
	$(foreach TARGET,$(DOCKER_TARGETS,$(sudo docker push $(subst $(COLON),:,$(TARGET)))))

deploy: deploy-deb deploy-docker