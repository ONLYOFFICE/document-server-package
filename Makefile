#NODE_MODULES_DIR = node_modules
#NODE_PROJECTS = sources
#NODE_PROJECTS_MODULES = $(addsuffix /$(NODE_MODULES_DIR), $(NODE_PROJECTS))
PACKAGE_NAME = onlyoffice-documentserver-enterprise
VERSION = 3.6.0

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

RPM = $(RPM_PACKAGE_DIR)/$(PACKAGE_NAME)-$(VERSION)-$(BUILD_NUMBER).$(RPM_ARCH).rpm
DEB = $(DEB_PACKAGE_DIR)/$(PACKAGE_NAME)_$(VERSION)-$(BUILD_NUMBER)_$(DEB_ARCH).deb

RPM_DOCUMENTSERVER = rpm/Files/documentserver
DEB_DOCUMENTSERVER = deb/$(PACKAGE_NAME)/Files/documentserver

ifeq ($(PACKAGE_NAME), onlyoffice-documentserver-enterprise)
DOCKERHUB_TRIGGER=https://registry.hub.docker.com/u/onlyoffice/4testing-documentserver-enterp/trigger/bd95e307-6a3f-4082-997e-6cc319157fc8/
else
DOCKERHUB_TRIGGER=https://registry.hub.docker.com/u/onlyoffice/4testing-documentserver/trigger/3a3e2739-74ac-4acc-ac82-9dcad3be67d7/
endif

.PHONY: all clean rpm deb clean-repo deploy deploy-rpm deploy-deb rpm-documentserver deb-documentserver docker

all: rpm deb

rpm: rpm-documentserver $(RPM)

deb: deb-documentserver $(DEB)

$(NODE_PROJECTS_MODULES):
	cd $(@D) && \
		npm install

clean:
	rm -rf node_modules

rpm-documentserver:
	cp -rf ../deploy/deploy/* $(RPM_DOCUMENTSERVER)/
	cp -rf ../dev_tools/OnlineEditorsExample/OnlineEditorsExampleNodeJS/ $(RPM_DOCUMENTSERVER)/example

	chmod u+x $(RPM_DOCUMENTSERVER)/NodeJsProjects/FileConverter/Bin/x2t
	chmod u+x $(RPM_DOCUMENTSERVER)/NodeJsProjects/FileConverter/Bin/HtmlFileInternal/HtmlFileInternal
	chmod u+x $(RPM_DOCUMENTSERVER)/Tools/AllFontsGen

	sed 's/{{BUILD_VERSION}}/'$(VERSION)'/'  -i rpm/$(PACKAGE_NAME).spec
	sed 's/{{BUILD_NUMBER}}/'${BUILD_NUMBER}'/'  -i rpm/$(PACKAGE_NAME).spec
	sed 's/{{DATE}}/'$$(date +%F)'/'  -i rpm/Files/nginx/onlyoffice-documentserver.conf
	sed 's/_dc=0/_dc='$$(date +%F)'/'  -i rpm/Files/documentserver/OfficeWeb/apps/api/documents/api.js

	sed 's/https:\/\/doc\.onlyoffice\.com/'http:\\/\\/localhost'/'  -i $(RPM_DOCUMENTSERVER)/example/config.js
	sed 's/http:\/\/localhost\/OfficeWeb/'\\/OfficeWeb'/'  -i $(RPM_DOCUMENTSERVER)/example/config.js
	sed 's/config\.haveExternalIp[[::space:]]=[[::space:]]false/'config\.haveExternalIp\ =\ true'/'  -i $(RPM_DOCUMENTSERVER)/example/config.js
  
deb-documentserver:
	cp -rf ../deploy/deploy/* $(DEB_DOCUMENTSERVER)/
	cp -rf ../dev_tools/OnlineEditorsExample/OnlineEditorsExampleNodeJS/ $(DEB_DOCUMENTSERVER)/example

	chmod u+x $(DEB_DOCUMENTSERVER)/NodeJsProjects/FileConverter/Bin/x2t
	chmod u+x $(DEB_DOCUMENTSERVER)/NodeJsProjects/FileConverter/Bin/HtmlFileInternal/HtmlFileInternal
	chmod u+x $(DEB_DOCUMENTSERVER)/Tools/AllFontsGen

	sed 's/{{BUILD_VERSION}}/'$(VERSION)'/'  -i deb/$(PACKAGE_NAME)/debian/changelog
	sed 's/{{BUILD_NUMBER}}/'${BUILD_NUMBER}'/'  -i deb/$(PACKAGE_NAME)/debian/changelog
	sed 's/{{DATE}}/'$$(date +%F)'/'  -i deb/$(PACKAGE_NAME)/Files/nginx/onlyoffice-documentserver
	sed 's/_dc=0/_dc='$$(date +%F)'/'  -i deb/$(PACKAGE_NAME)/Files/documentserver/OfficeWeb/apps/api/documents/api.js

	sed 's/https:\/\/doc\.onlyoffice\.com/'http:\\/\\/localhost'/'  -i $(DEB_DOCUMENTSERVER)/example/config.js
	sed 's/http:\/\/localhost\/OfficeWeb/'\\/OfficeWeb'/'  -i $(DEB_DOCUMENTSERVER)/example/config.js
  	sed 's/config\.haveExternalIp[[::space:]]=[[::space:]]false/'config\.haveExternalIp\ =\ true'/'  -i $(DEB_DOCUMENTSERVER)/example/config.js

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
	aws s3 cp s3://repo-doc-onlyoffice-com/$(RPM_REPO_DIR)/$(PACKAGE_NAME)/$(SVN_TAG) s3://repo-doc-onlyoffice-com/archive/$(RPM_REPO_DIR)/ --acl public-read --recursive --include '*.rpm' --exclude '*'
endif

deploy-deb: $(DEB)
	rm -rfv $(REPO)
	mkdir -p $(REPO)

	cp -rv $(DEB) $(REPO);
	dpkg-scanpackages -m repo /dev/null | gzip -9c > $(REPO)/Packages.gz

	aws s3 sync $(REPO) s3://repo-doc-onlyoffice-com/$(DEB_REPO_DIR)/$(PACKAGE_NAME)/$(SVN_TAG)/repo --acl public-read --delete

ifeq ($(SVN_TAG), trunk)
	aws s3 cp s3://repo-doc-onlyoffice-com/$(DEB_REPO_DIR)/$(PACKAGE_NAME)/$(SVN_TAG)/repo s3://repo-doc-onlyoffice-com/archive/$(DEB_REPO_DIR)/ --acl public-read --recursive --include '*.deb' --exclude '*'
endif

docker:
ifeq ($(SVN_TAG), trunk)
	curl -H "Content-Type: application/json" --data '{"build": true}' -X POST $(DOCKERHUB_TRIGGER)
endif