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

%install

%clean
rm -rf "%{buildroot}"

%files

%dir

%pre

case "$1" in
  1)
    # Initial installation
  ;;
  2)
    # Upgrade
  ;;
esac
exit 0

%post

IS_UPGRADE="false"

case "$1" in
  1)
    # Initial installation
  ;;
  2)
    # Upgrade database
  ;;
esac

%preun

case "$1" in
  0)
    # Uninstall
  ;;
  1)
    # Upgrade
    :
  ;;
esac

%postun

case "$1" in
  0)
    # Uninstall
  ;;
  1)
    # Upgrade
    :
  ;;
esac

%changelog
