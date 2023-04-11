include(variables.m4)
License: AGPL

%define _package_summary defn(`RPM[Summary]')
%define _package_description defn(`RPM[Description]')

%global package_services M4_PACKAGE_SERVICES

%include requires.spec
%include vars.spec
%include ../rpm-core/common.spec
