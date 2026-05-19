include(variables.m4)
License: ifelse(regexp(M4_PACKAGE_NAME, `documentserver$'), -1, Proprietary, AGPL-3.0-only and CC-BY-SA-4.0)

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
%define example 1,)
ifelse(regexp(M4_PACKAGE_NAME, `documentserver$'),-1,
%define is_commercial 1,)
%define DS_PLUGIN_INSTALLATION M4_DS_PLUGIN_INSTALLATION
%define _package_summary defn(`RPM[Summary]')
%define _package_description defn(`RPM[Description]')

%global package_services M4_PACKAGE_SERVICES

%include requires.spec
%include vars.spec
%include common.spec
