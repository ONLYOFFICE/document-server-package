%define __strip    /bin/true
Summary: %{_package_summary}
Name: %{_package_name}
Version: %{_product_version}
Release: %{_build_number}
Group: Applications/Internet
URL: %{_publisher_url}
Vendor: %{_publisher_name}
Packager: %{_publisher_name} <%{_support_mail}>
AutoReq: no
AutoProv: no

%description
%{_package_description}

%prep
rm -rf "%{buildroot}"

%build

%define _build_id_links none

%install

DOCUMENTSERVER_HOME=%{_builddir}/../../../common/documentserver/home
DOCUMENTSERVER_EXAMPLE_HOME=%{_builddir}/../../../common/documentserver-example/home
DOCUMENTSERVER_EXAMPLE_CONFIG=%{_builddir}/../../../common/documentserver-example/config

BIN_DIR=%{buildroot}%{_bindir}
DATA_DIR=%{buildroot}%{_localstatedir}/lib/%{_ds_prefix}
CONF_DIR=%{buildroot}%{_sysconfdir}/%{_ds_prefix}
HOME_DIR=%{buildroot}%{_localstatedir}/www/%{_ds_prefix}
LIB_DIR=%{buildroot}%{_libdir}
LOG_DIR=%{buildroot}%{_localstatedir}/log/%{_ds_prefix}

#install documentserver npm files
mkdir -p "${HOME_DIR}-example/npm"
cp -r $DOCUMENTSERVER_HOME/npm/* "${HOME_DIR}-example/npm/"

#install documentserver example bin
mkdir -p "$BIN_DIR/"
cp -r %{_builddir}/../../bin/*.sh "$BIN_DIR/"

#install documentserver example files
mkdir -p "${HOME_DIR}-example/"
cp -r $DOCUMENTSERVER_EXAMPLE_HOME/* "${HOME_DIR}-example/"

#install dcoumentserver example configs
mkdir -p "${CONF_DIR}-example/"
cp -r $DOCUMENTSERVER_EXAMPLE_CONFIG/* "${CONF_DIR}-example/" 

#make log dir
mkdir -p "${LOG_DIR}-example"

# create data dir
mkdir -p "${DATA_DIR}-example/files/"

#install example systemd services
mkdir -p %{buildroot}/usr/lib/systemd/system
cp %{_builddir}/../../../common/documentserver-example/systemd/*.service %{buildroot}/usr/lib/systemd/system

#install nginx config
DSE_NGINX_CONF=${CONF_DIR}-example/nginx
mkdir -p "$DSE_NGINX_CONF/includes"
cp -r %{_builddir}/../../../common/documentserver-example/nginx/includes/*.conf "$DSE_NGINX_CONF/includes"
cp -r %{_builddir}/../../../common/documentserver-example/nginx/*.conf "$DSE_NGINX_CONF"

NGINX_INCLUDES_DIR=%{buildroot}%{_sysconfdir}/nginx/includes
NGINX_CONFD_DIR=%{buildroot}%{_sysconfdir}/nginx/%{nginx_conf_d}

mkdir -p ${NGINX_INCLUDES_DIR}
mkdir -p ${NGINX_CONFD_DIR}

# Make symlinks for nginx configs
find \
  ${CONF_DIR}-example/nginx/includes \
  -name *.conf \
  -exec sh -c '%__ln_s {} %{buildroot}%{_sysconfdir}/nginx/includes/$(basename {})' \;

if [ ! -e ${NGINX_CONFD_DIR}/dse.conf ]; then
  %__ln_s \
    $CONF_DIR-example/nginx/ds.conf \
    ${NGINX_CONFD_DIR}/dse.conf
fi

# Convert absolute links to relative links
symlinks -c \
  ${NGINX_CONFD_DIR} \
  ${NGINX_INCLUDES_DIR}

# index.html for rpm
sed 's/linux.html/linux-rpm.html/g' -i "$DSE_NGINX_CONF/includes/ds-example.conf"


%clean
rm -rf "%{buildroot}"

%files

%defattr(440, ds, ds, 555)
%{_localstatedir}/www/%{_ds_prefix}*/*

%attr(550, ds, ds) %{_localstatedir}/www/%{_ds_prefix}-example/example
%attr(550, ds, ds) %{_localstatedir}/www/%{_ds_prefix}-example/npm/json

%config %{_sysconfdir}/%{_ds_prefix}*/*.json

%config %{_sysconfdir}/%{_ds_prefix}*/nginx/includes/*

%config(noreplace) %{_sysconfdir}/%{_ds_prefix}-example/nginx/ds.conf

%attr(-, root, root) %{_sysconfdir}/nginx/%{nginx_conf_d}/*
%attr(-, root, root) %{_sysconfdir}/nginx/includes/*
%attr(644, root, root) /usr/lib/systemd/system/*
%attr(744, root, root) %{_bindir}/documentserver-*.sh

%dir

%attr(755, ds, ds) %{_localstatedir}/log/%{_ds_prefix}-example
%attr(750, ds, ds) %{_localstatedir}/lib/%{_ds_prefix}-example

%pre

# add group and user for onlyoffice app
getent group ds >/dev/null || groupadd -r ds
getent passwd ds >/dev/null || useradd -r -g ds -d %{_localstatedir}/www/%{_ds_prefix}/ -s /sbin/nologin ds
# add nginx user to onlyoffice group to allow access nginx to onlyoffice log dir
usermod -a -G ds %{nginx_user}

case "$1" in
  1)
    # Initial installation
  ;;
  2)
    # Upgrade

    echo "Stopping documentserver services..."
    if [ -e /usr/lib/systemd/system/ds-example.service ]; then
      systemctl stop ds-example
    fi
  ;;
esac
exit 0

%post

NGINX_CONFD="/etc/nginx/conf.d"
CONF_DIR=%{_sysconfdir}/%{_ds_prefix}

# Backup dse.conf if ds installed
if [ -h ${NGINX_CONFD}/ds.conf ]; then
  mkdir -p $CONF_DIR/dse
  mv ${NGINX_CONFD}/dse.conf $CONF_DIR/dse
fi

chown -R ds:ds %{_localstatedir}/lib/%{_ds_prefix}-example

IS_UPGRADE="false"

case "$1" in
  1)
    # Initial installation
  ;;
  2)
    # Upgrade database
    IS_UPGRADE="true"
  ;;
esac

if [ "$IS_UPGRADE" = "true" ]; then
  chown -R ds:ds %{_localstatedir}/log/%{_ds_prefix}-example
fi

# check whethere enabled
shopt -s nocasematch
PORTS=()
case $(%{getenforce}) in
  enforcing|permissive)
    PORTS+=('3000')
    %{setsebool} -P httpd_can_network_connect on
  ;;
  disabled)
    :
  ;;
esac

# add selinux extentions
for PORT in ${PORTS[@]}; do
  %{semanage} port -a -t http_port_t -p tcp $PORT >/dev/null 2>&1 || \
    %{semanage} port -m -t http_port_t -p tcp $PORT >/dev/null 2>&1 || \
    true
done

#restart dependent services
systemctl daemon-reload
if [ -e /usr/lib/systemd/system/ds-example.service ]; then
  systemctl enable ds-example
  systemctl restart ds-example
fi

if systemctl is-active --quiet nginx; then
  systemctl reload nginx >/dev/null 2>&1
fi

%preun

NGINX_CONFD="/etc/nginx/conf.d"
CONF_DIR=%{_sysconfdir}/%{_ds_prefix}

# Restore dse.conf for uninstall
if [ -h ${CONF_DIR}/dse/dse.conf ]; then
  if [ ! -h ${NGINX_CONFD}/dse.conf ]; then
    mv ${CONF_DIR}/dse/dse.conf ${NGINX_CONFD}
  fi
  rm -r ${CONF_DIR}/dse
fi

case "$1" in
  0)
    # Uninstall
    # disconnect all users and stop running services

    if [ -e /usr/lib/systemd/system/ds-example.service ]; then
      systemctl stop ds-example
    fi
  ;;
  1)
    # Upgrade
    :
  ;;
esac

%postun
DIR="%{_localstatedir}/www/%{_ds_prefix}"

case "$1" in
  0)
    # Uninstall
    :
  ;;
  1)
    # Upgrade
    :
  ;;
esac

if systemctl is-active --quiet nginx; then
  systemctl reload nginx >/dev/null 2>&1
fi

%changelog
