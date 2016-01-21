FROM ubuntu:14.04
MAINTAINER Ascensio System SIA <support@onlyoffice.com>

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

RUN apt-get update && apt-get -y -q install curl

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d && \
    echo  "deb http://repo-doc-onlyoffice-com.s3.amazonaws.com/ubuntu/trusty/onlyoffice-documentserver/trunk/ repo/" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D9D0BF019CC8AC0D && \
    echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keys.gnupg.net --recv-keys 5072E1F5 && \
    echo "deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.6" | tee /etc/apt/sources.list.d/mysql.list && \
    curl -sL https://deb.nodesource.com/setup_4.x | sudo bash - && \
    DEBIAN_FRONTEND=noninteractive  && \
    locale-gen en_US.UTF-8 && \
    apt-get -y update && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    apt-get install --force-yes -yq software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get -y update && \
    apt-get --force-yes -yq install gcc-4.9 onlyoffice-documentserver nano htop && \
    rm -rf /var/lib/apt/lists/*

ADD config /app/onlyoffice/setup/config/
ADD run-document-server.sh /app/onlyoffice/run-document-server.sh
RUN chmod 755 /app/onlyoffice/*.sh

VOLUME ["/var/log/onlyoffice"]
VOLUME ["/var/www/onlyoffice/Data"]

EXPOSE 80
EXPOSE 443

CMD bash -C '/app/onlyoffice/run-document-server.sh';'bash'
