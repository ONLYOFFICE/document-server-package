changecom(`;',)
#define sCompanyName        'COMPANY_NAME'
#define sProductName        'PRODUCT_NAME'
#define sPublisherName      'PUBLISHER_NAME'
#define sPublisherUrl       'PUBLISHER_URL'
#define sSupportUrl         'SUPPORT_URL'

#include "common.iss"

ifelse('M4_DS_EXAMPLE_ENABLE', '1',
#include "example.iss"
,)

