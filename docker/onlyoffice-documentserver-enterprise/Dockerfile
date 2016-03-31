FROM ubuntu:14.04
MAINTAINER Ascensio System SIA <support@onlyoffice.com>

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d && \
    apt-get -y update && \
    apt-get --force-yes -yq install apt-transport-https && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D9D0BF019CC8AC0D && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1655A0AB68576280 && \
    echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://deb.nodesource.com/node_4.x trusty main" | tee /etc/apt/sources.list.d/nodesource.list && \
    DEBIAN_FRONTEND=noninteractive  && \
    locale-gen en_US.UTF-8 && \
    apt-get -y update && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    echo onlyoffice-documentserver-enterprise onlyoffice/accepted-onlyoffice-license select true | debconf-set-selections && \
    apt-get install --force-yes -yq software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get -y update && \
    apt-get --force-yes -yq install software-properties-common adduser mysql-server redis-server rabbitmq-server nginx-extras nodejs libstdc++6 libcurl3 libxml2 libboost-regex-dev zlib1g supervisor fonts-dejavu fonts-liberation ttf-mscorefonts-installer fonts-crosextra-carlito fonts-takao-gothic fonts-opensymbol libxss1 libgtkglext1 libcairo2 xvfb libxtst6 libgconf2-4 libasound2 bomstrip libnspr4 libnss3 libnss3-nssdb nano htop && \
    service mysql stop && \
    service redis-server stop && \
    service rabbitmq-server stop && \
    service supervisor stop && \
    service nginx stop && \
    rm -rf /var/lib/apt/lists/*

RUN echo "deb http://repo-doc-onlyoffice-com.s3.amazonaws.com/ubuntu/trusty/onlyoffice-documentserver-enterprise/{{SVN_TAG}}/{{PACKAGE_VERSION}}/ repo/" >> /etc/apt/sources.list && \
    DEBIAN_FRONTEND=noninteractive  && \
    apt-get -y update && \
    service mysql start && \
    apt-get --force-yes -yq install onlyoffice-documentserver-enterprise && \
    service mysql stop && \
    rm -rf /var/lib/apt/lists/*

ADD config /app/onlyoffice/setup/config/
ADD run-document-server.sh /app/onlyoffice/run-document-server.sh
RUN chmod 755 /app/onlyoffice/*.sh

VOLUME ["/var/log/onlyoffice"]
VOLUME ["/var/www/onlyoffice/Data"]

EXPOSE 80
EXPOSE 443

CMD bash -C '/app/onlyoffice/run-document-server.sh';'bash'
