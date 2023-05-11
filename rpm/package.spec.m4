include(variables.m4)
License: AGPL

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
%define example 1,)
%define DS_PLUGIN_INSTALLATION M4_DS_PLUGIN_INSTALLATION
%define _package_summary defn(`RPM[Summary]')
%define _package_description defn(`RPM[Description]')

%global package_services M4_PACKAGE_SERVICES

%include requires.spec
%include vars.spec
%include common.spec
