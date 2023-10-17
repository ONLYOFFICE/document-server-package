; -- ONLYOFFICE Defines --

#define sCompanyName        'ONLYOFFICE'
#define sIntCompanyName     'ONLYOFFICE'
#define sProductName        'Document Server'
#define sIntProductName     'DocumentServer'
#define sPublisherName      'Ascensio System SIA'
#define sAppCopyright       'Copyright (C) ' + GetDateTimeString('yyyy',,) + ' ' + sPublisherName
#define sPublisherUrl       'http://www.onlyoffice.com'
#define sSupportURL         'http://support.onlyoffice.com'
#define sUpdatesURL         'http://www.onlyoffice.com'
; #define sPublisherUrl       'https://www.onlyoffice.com/'
; #define sSupportURL         'https://www.onlyoffice.com/support.aspx'
; #define sUpdatesURL         'https://www.onlyoffice.com/'

#define sAppName            'ONLYOFFICE Document Server'
#define sAppId              'ONLYOFFICE DocumentServer'
#define sAppPath            'ONLYOFFICE\DocumentServer'
#define sAppRegPath         'Software\ONLYOFFICE\DocumentServer'

#if SameText(EDITION, 'developer') | SameText(EDITION, 'enterprise')
#define sProductName        sProductName + ' ' + UpperCase(Copy(EDITION,1,1)) + 'E'
#define sAppName            sAppName + ' ' + UpperCase(Copy(EDITION,1,1)) + 'E'
#endif

#define sDbDefValue         'onlyoffice'
#define DS_EXAMPLE
#define DS_PLUGIN_INSTALLATION
