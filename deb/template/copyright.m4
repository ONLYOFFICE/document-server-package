Format: http://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: M4_PUBLISHER_NAME
Upstream-Contact: M4_PUBLISHER_NAME <M4_SUPPORT_MAIL>
Source: M4_PUBLISHER_URL

Files: *
Copyright: (c) Copyright M4_PUBLISHER_NAME, 2009-M4_CURRENT_YEAR <M4_SUPPORT_MAIL>
ifelse(regexp(M4_PACKAGE_NAME, `documentserver$'), -1,
`License: Proprietary',
`License: AGPL-3.0-only')

ifelse(regexp(M4_PACKAGE_NAME, `documentserver$'), -1,,
`Files: *.gif *.ico *.jpg *.png *.svg
Copyright: (c) Copyright M4_PUBLISHER_NAME, 2009-M4_CURRENT_YEAR <M4_SUPPORT_MAIL>
License: CC-BY-SA-4.0')
