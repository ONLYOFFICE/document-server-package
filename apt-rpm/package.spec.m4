License: AGPL

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
%define example 1,)

%include requires.spec
%include vars.spec
%include ../rpm/common.spec
