FROM {{OS}}:{{VERSION}}
MAINTAINER Ascensio System SIA <support@onlyoffice.com>

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive QT_SELECT=opt-qt55

RUN apt-get -y update && \
    apt-get install --force-yes -yq apt-transport-https locales software-properties-common && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1655A0AB68576280 && \
    echo "deb https://deb.nodesource.com/node_4.x {{VERSION}} main" | tee /etc/apt/sources.list.d/nodesource.list && \
    add-apt-repository ppa:beineri/opt-qt551-trusty && \
    locale-gen en_US.UTF-8 && \
    apt-get -y update && \
    apt-get install --force-yes -yq \
        wget \
        build-essential \
        sed \
        dpkg-dev \
        debhelper \
        createrepo \
        bomstrip \
        libxml2-dev \
        libboost-regex-dev \
        libboost-system-dev \
        libboost-filesystem-dev \
        libcurl4-gnutls-dev \
        libglib2.0-dev \
        libgdk-pixbuf2.0-dev \
        libgtkglext1-dev \
        libatk1.0-dev \
        libcairo2-dev \
        libxss-dev \
        libgconf2-dev \
        default-jre \
        qtchooser \
        qt-latest \
        nodejs && \
    npm install -g grunt-cli && \
    npm cache clean && \
    rm -rf /var/lib/apt/lists/*

ADD build.sh /app/onlyoffice/build.sh

VOLUME /var/lib/onlyoffice /home/oleg

CMD bash -C '/app/onlyoffice/build.sh'
