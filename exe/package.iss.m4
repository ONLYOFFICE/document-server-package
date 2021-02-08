changecom(`;',)
#define sCompanyName        'M4_COMPANY_NAME'
#define sProductName        'M4_PRODUCT_NAME'
#define sPublisherName      'M4_PUBLISHER_NAME'
#define sPublisherUrl       'M4_PUBLISHER_URL'
#define sSupportUrl         'M4_SUPPORT_URL'

#define sBrandingFolder     'esyscmd(cygpath -a -w M4_BRANDING_DIR)'
#define sDbDefValue         'M4_ONLYOFFICE_VALUE'

#include "common.iss"

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
#include "example.iss"
,)

