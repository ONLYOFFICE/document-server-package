%package        plugin
Summary:        %{_package_summary}
Group:          Applications/Internet
AutoReqProv:    no
%description
%{_package_description}

%files plugin
%attr(550, ds, ds) %{_localstatedir}/www/%{_ds_prefix}/server/tools/pluginsmanager
%attr(744, root, root) %{_bindir}/documentserver-pluginsmanager.sh

%post plugin
PLUGINS_LIST=("highlight code" "macros" "mendeley" "ocr" "photo editor" "speech" "thesaurus" "translator" "youtube" "zotero")
INSTALLED_PLUGINS=$(documentserver-pluginsmanager.sh -r false --print-installed)
for PLUGIN in "${PLUGINS_LIST[@]}"; do
    !(grep -q "$PLUGIN" <<< "$INSTALLED_PLUGINS") && PLUGIN_INSTALL_LIST+=("$PLUGIN")
done
if grep -cq "{" <<< "$INSTALLED_PLUGINS"; then 
    echo -n Update plugins, please wait...
    documentserver-pluginsmanager.sh -r false --update-all >/dev/null
    echo Done
fi
if [ ${#PLUGIN_INSTALL_LIST[@]} -gt 0 ]; then
    echo -n Install plugins, please wait...
    documentserver-pluginsmanager.sh -r false --install="$(printf "%s," "${PLUGIN_INSTALL_LIST[@]}")" >/dev/null
    echo Done
fi

%postun plugin
[ -d %{_localstatedir}/www/%{_ds_prefix}/sdkjs-plugins/ ] && rm -rf %{_localstatedir}/www/%{_ds_prefix}/sdkjs-plugins/
