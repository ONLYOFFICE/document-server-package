#ifndef sBrandingFolder
  #define sBrandingFolder '..\branding'
#endif

#define sBrandingFile str(sBrandingFolder + "\exe\branding.iss")

#if FileExists(sBrandingFile)
  #include str(sBrandingFile)
#endif

#ifndef sCompanyName
  #define sCompanyName        'ONLYOFFICE'
#endif

#ifndef sIntCompanyName
  #define sIntCompanyName     str(sCompanyName)
#endif

#ifndef sProductName
  #define sProductName        'DocumentServer'
#endif

#ifndef sIntProductName
  #define sIntProductName     'DocumentServer'
#endif

#ifndef sPackageName
  #define sPackageName        str(LowerCase(sCompanyName) + "-" + LowerCase(sProductName))
#endif

#define sLicenseFile str(sBrandingFolder + "\common\documentserver\license\" + sPackageName + "\LICENSE.txt")
#ifnexist sLicenseFile
  #define sLicenseFile str(sBrandingFolder + "\common\documentserver\license\onlyoffice-documentserver\LICENSE.txt")
#endif

#ifndef sPublisherName
  #define sPublisherName      'Ascensio System SIA'
#endif

#ifndef sAppCopyright
  #define sAppCopyright      str("Copyright (C) " + GetDateTimeString('yyyy',,) + " " + sPublisherName)
#endif

#ifndef sPublisherUrl
  #define sPublisherUrl       'https://www.onlyoffice.com/'
#endif

#ifndef sSupportURL
  #define sSupportURL=str(sPublisherUrl + "support.aspx")
#endif

#ifndef sUpdatesURL
  #define sUpdatesURL=str(sPublisherUrl)
#endif

#ifndef sAppName
  #define sAppName            str(sCompanyName + " " + sProductName)
#endif

#ifndef sAppId
	#define sAppId              str(sIntCompanyName + " " + sIntProductName)
#endif

#ifndef sAppPath
  #define sAppPath            str(sIntCompanyName + "\" + sIntProductName)
#endif

#ifndef sAppRegPath
  #define sAppRegPath        str("Software\" + sIntCompanyName + "\" + sIntProductName)
#endif

#define REG_LICENSE_PATH      'LicensePath'
#define REG_DB_HOST           'DbHost'
#define REG_DB_USER           'DbUser'
#define REG_DB_PWD            'DbPwd'
#define REG_DB_NAME           'DbName'
#define REG_RABBITMQ_HOST     'RabbitMqHost'
#define REG_RABBITMQ_USER     'RabbitMqUser'
#define REG_RABBITMQ_PWD      'RabbitMqPwd'
#define REG_RABBITMQ_PROTO    'RabbitMqProto'
#define REG_REDIS_HOST        'RedisHost'
#define REG_DS_PORT           'DsPort'
#define REG_EXAMPLE_PORT      'ExamplePort'
#define REG_DOCSERVICE_PORT   'DocServicePort'
#define REG_FONTS_PATH        'FontsPath'
#define REG_JWT_ENABLED       'JwtEnabled'
#define REG_JWT_SECRET        'JwtSecret'
#define REG_JWT_HEADER        'JwtHeader'

#define iconsExe            'projicons.exe'

#ifndef sAppVerShort
	#define sAppVerShort	'0.0.0'
#endif

#ifndef sAppBuildNumber
	#define sAppBuildNumber	'0'
#endif

#ifndef sAppVersion
  #define sAppVersion         str(sAppVerShort + '.' + sAppBuildNumber)
#endif

#ifndef sDbDefValue
  #define sDbDefValue         'onlyoffice'
#endif

#define NSSM                  '{app}\nssm\nssm.exe'
#define NODE_ENV	          'NODE_ENV=production-windows'
#define NODE_CONFIG_DIR       'NODE_CONFIG_DIR=""{app}\config""'
#define NODE_DISABLE_COLORS   'NODE_DISABLE_COLORS=1'
#define APPLICATION_NAME      str("APPLICATION_NAME=" + sCompanyName)
#define NODE_SRV_ENV          str(NODE_ENV + ' ' + NODE_CONFIG_DIR + ' ' + NODE_DISABLE_COLORS + ' ' + APPLICATION_NAME)

#define LOCAL_SERVICE 'NT Authority\LocalService'

#define CONVERTER_SRV        'DsConverterSvc'
#define CONVERTER_SRV_DISPLAY  str(sAppName + " Converter")
#define CONVERTER_SRV_DESCR  str(sAppName + " Converter Service")
#define CONVERTER_SRV_DIR    '{app}\server\FileConverter'
#define CONVERTER_SRV_LOG_DIR    '{app}\Log\converter'

#define DOCSERVICE_SRV        'DsDocServiceSvc'
#define DOCSERVICE_SRV_DISPLAY  str(sAppName + " DocService")
#define DOCSERVICE_SRV_DESCR  str(sAppName + " DocService Service")
#define DOCSERVICE_SRV_DIR    '{app}\server\docservice'
#define DOCSERVICE_SRV_LOG_DIR    '{app}\Log\docservice'

#define PSQL '{app}\pgsql\bin\psql.exe'
#define POSTGRESQL_DATA_DIR '{userappdata}\postgresql'

#define JSON '{app}\npm\json.exe'

#define JSON_PARAMS '-I -q -f ""{app}\config\local.json""'

#define REPLACE '{app}\npm\replace.exe'

#define NGINX_SRV  'DsProxySvc'
#define NGINX_SRV_DISPLAY  str(sAppName + " Proxy")
#define NGINX_SRV_DESCR  str(sAppName + " Proxy Service")
#define NGINX_SRV_DIR  '{app}\nginx'
#define NGINX_SRV_LOG_DIR    '{app}\Log\nginx'
#define NGINX_DS_CONF '{app}\nginx\conf\ds.conf'
#define NGINX_DS_TMPL '{app}\nginx\conf\ds.conf.tmpl'
#define NGINX_DS_SSL_TMPL '{app}\nginx\conf\ds-ssl.conf.tmpl'
#define NGINX_SRV_ENV 'OPENSSL_CONF=openssl\openssl.conf'

#define LICENSE_PATH str("{commonappdata}\" + sIntCompanyName + "\Data")

#define LogRotateTaskName str(sAppName + " Log Rotate Task")
#define LOG_ROTATE_BYTES 10485760

#define PythonPath '{sd}\Python'
#define Python str(PythonPath + "\python.exe")
#define Pip str(PythonPath + "\scripts\pip.exe")
#define RabbitMq 'RabbitMQ'
#define PostgreSQL 'PostgreSQL'
#define Redis 'Redis'

#define public Dependency_NoExampleSetup
#include "InnoDependencyInstaller\CodeDependencies.iss"
#include "products.iss"

[Setup]
AppName                   ={#sAppName}
AppId                     ={#sAppId}
AppVerName                ={#sAppName} {#sAppVerShort}
AppVersion                ={#sAppVersion}
VersionInfoVersion        ={#sAppVersion}
OutputBaseFilename        ={#sPackageName}-{#sAppVersion}

AppPublisher            ={#sPublisherName}
AppPublisherURL         ={#sPublisherUrl}
AppSupportURL           ={#sSupportURL}
AppUpdatesURL           ={#sUpdatesURL}
AppCopyright            ={#sAppCopyright}


ArchitecturesAllowed              =x64
ArchitecturesInstallIn64BitMode   =x64

DefaultGroupName        ={#sCompanyName}
;WizardImageFile         = data\dialogpicture.bmp
;WizardSmallImageFile    = data\dialogicon.bmp


UsePreviousAppDir         = yes
DirExistsWarning          =no
DefaultDirName            ={pf}\{#sAppPath}
DisableProgramGroupPage   = yes
DisableWelcomePage        = no
DEPCompatible             = no
ASLRCompatible            = no
DisableDirPage            = auto
AllowNoIcons              = yes
AlwaysShowDirOnReadyPage  = yes
UninstallDisplayIcon      = {uninstallexe}
OutputDir                 =.\
Compression               =zip
PrivilegesRequired        =admin
ChangesEnvironment        =yes
SetupMutex                =ASC
MinVersion                =6.1.7600
WizardImageFile           = {#sBrandingFolder}\exe\data\dialogpicture.bmp
WizardSmallImageFile      = {#sBrandingFolder}\exe\data\dialogicon.bmp
SetupIconFile             = {#sBrandingFolder}\exe\data\icon.ico
LicenseFile               = 
ShowLanguageDialog        = no

#ifdef ENABLE_SIGNING
SignTool=byparam $p
#endif

[CustomMessages]
en.AddRotateTask=Adding scheduled tasks...
ru.AddRotateTask=Добавление задачи в планировщик...

en.CfgDs=Configuring {#sAppName}...
ru.CfgDs=Настройка {#sAppName}...

en.CfgSrv=Configuring service %1...
ru.CfgSrv=Настройка сервиса %1...

en.CreateDb=Creating database...
ru.CreateDb=Создание базы данных...

en.DependenciesDir={#sAppName} Dependencies
ru.DependenciesDir={#sAppName} Зависимости

en.FireWallExt=Adding firewall extention...
ru.FireWallExt=Добавление исключения в файервол ...

en.GenFonts=Generating AllFonts.js...
ru.GenFonts=Создание AllFonts.js...

en.InstallSrv=Installing service %1...
ru.InstallSrv=Установка сервиса %1...

en.PrevVer=The previous version of {#sAppName} detected, please click 'OK' button to uninstall it, or 'Cancel' to quit setup.
ru.PrevVer=Обнаружена предыдущая версия {#sAppName}, нажмите кнопку 'OK' что бы удалить ей, или 'Отменить' что бы выйти из программы инсталляции.

en.RemoveDb=Removing database...
ru.RemoveDb=Удаление базы данных...

en.StartSrv=Starting service %1...
ru.StartSrv=Запуск сервиса %1...

en.Uninstall=Uninstall {#sAppName}
ru.Uninstall=Удаление {#sAppName}

en.Program=Program components
ru.Program=Компоненты программы

en.Prerequisites=Download prerequisites
ru.Prerequisites=Загрузить необходимое ПО

en.FullInstall=Full installation
ru.FullInstall=Полная установка

en.CompactInstall=Compact installation
ru.CompactInstall=Компактная установка

en.CustomInstall=Custom installtion
ru.CustomInstall=Выборочная установка

en.Postgre=PostgreSQL Database
ru.Postgre=База данных PostgreSQL

en.PostgreDb=Database:
ru.PostgreDb=База данных:

en.RabbitMq=RabbitMQ Messaging Broker
ru.RabbitMq=Брокер обмена сообщениями RabbitMQ

en.Redis=Redis In-Memory Database
ru.Redis=Хранилище структур данных Redis

en.Host=Host
ru.Host=Хост

en.Port=Port
ru.Port=Порт

en.User=User
ru.User=Пользователь

en.Password=Password
ru.Password=Пароль

en.Protocol=Protocol
ru.Protocol=Протокол

en.PackageConfigure=Configure Connection to %1
ru.PackageConfigure=Настройка соединения с %1

en.PackageConnection=Please specify your %1 connection, then click Next.
ru.PackageConnection=Укажите параметры подключения к %1 и нажмите «Далее»

en.CheckConnection=Connection to %1 failed! %n%2 return code %3%nCheck the connection settings and try again.
ru.CheckConnection=Соединение с %1 не удалось! %n%2 вернул код ошибки %3%nПроверьте настройки соединения и попробуйте снова.

en.NotAvailable=%1 isn't installed or unreachable,
ru.NotAvailable=%1 не установлен или недоступен,

en.SkipValidation=%1 parameters validation will be skipped.
ru.SkipValidation=будет пропущена проверка параметров %1

en.CheckFailed=Failed to check parameters,
ru.CheckFailed=Ошибка проверки параметров

en.UsePort=Port %1 is in use. The installation will continue, but the operation of the application is not guaranteed.
ru.UsePort=Порт %1 используется. Инсталляция будет продолжена, но работа приложения не гарантируется.

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
;Name: "de"; MessagesFile: "compiler:Languages\German.isl"
;Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
;Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
;Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
;Name: "pl"; MessagesFile: "compiler:Languages\Polish.isl"

[Files]
Source: ..\common\documentserver\home\*;            DestDir: {app}; Flags: ignoreversion recursesubdirs; Components: Program
Source: ..\common\documentserver\config\*;          DestDir: {app}\config; Flags: ignoreversion recursesubdirs; Permissions: users-readexec; Components: Program
Source: local\local.json;                           DestDir: {app}\config; Flags: onlyifdoesntexist uninsneveruninstall; Components: Program
Source: ..\common\documentserver\bin\*.bat;         DestDir: {app}\bin; Flags: ignoreversion recursesubdirs; Components: Program
Source: ..\common\documentserver\bin\*.ps1;         DestDir: {app}\bin; Flags: ignoreversion recursesubdirs; Components: Program
Source: nginx\nginx.conf;                           DestDir: {#NGINX_SRV_DIR}\conf; Flags: ignoreversion recursesubdirs; Components: Program
Source: ..\common\documentserver\nginx\includes\*.conf;  DestDir: {#NGINX_SRV_DIR}\conf\includes; Flags: ignoreversion recursesubdirs; Components: Program
Source: ..\common\documentserver\nginx\*.tmpl;  DestDir: {#NGINX_SRV_DIR}\conf; Flags: ignoreversion recursesubdirs; Components: Program
Source: ..\common\documentserver\nginx\ds.conf; DestDir: {#NGINX_SRV_DIR}\conf; Flags: onlyifdoesntexist uninsneveruninstall; Components: Program
Source: scripts\connectionRabbit.py;            DestDir: "{app}"; Flags: ignoreversion; Components: Program
Source: data\vcredist\vcredist_2022_x64.exe; DestDir: {app}; Flags: deleteafterinstall; \
  AfterInstall: installVCRedist(ExpandConstant('{app}\vcredist_2022_x64.exe'), ExpandConstant('{cm:InstallAdditionalComponents}')); \
  Check: not checkVCRedist2022;

[Dirs]
Name: "{app}\server\App_Data";        Permissions: service-modify
Name: "{app}\server\App_Data\cache\files"; Permissions: service-modify
Name: "{app}\server\App_Data\docbuilder"; Permissions: service-modify
Name: "{app}\sdkjs";                  Permissions: users-modify
Name: "{app}\fonts";                  Permissions: users-modify
Name: "{#CONVERTER_SRV_LOG_DIR}";     Permissions: service-modify
Name: "{#DOCSERVICE_SRV_LOG_DIR}";    Permissions: service-modify
Name: "{#NGINX_SRV_DIR}";             Permissions: service-modify
Name: "{#NGINX_SRV_LOG_DIR}";         Permissions: service-modify
Name: "{#NGINX_SRV_DIR}\temp";        Permissions: service-modify
Name: "{#NGINX_SRV_DIR}\logs";        Permissions: service-modify
Name: "{#POSTGRESQL_DATA_DIR}";
Name: "{#LICENSE_PATH}";

[Icons]
Name: "{group}\{cm:Uninstall}"; Filename: "{uninstallexe}"

[Registry]
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_DB_HOST}"; ValueData: "{code:GetDbHost}";
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_DB_USER}"; ValueData: "{code:GetDbUser}";
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_DB_PWD}"; ValueData: "{code:GetDbPwd}";
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_DB_NAME}"; ValueData: "{code:GetDbName}";
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_RABBITMQ_HOST}"; ValueData: "{code:GetRabbitMqHost}";
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_RABBITMQ_USER}"; ValueData: "{code:GetRabbitMqUser}";
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_RABBITMQ_PWD}"; ValueData: "{code:GetRabbitMqPwd}";
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_RABBITMQ_PROTO}"; ValueData: "{code:GetRabbitMqProto}";
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_REDIS_HOST}"; ValueData: "{code:GetRedisHost}"; Check: IsCommercial;
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_LICENSE_PATH}"; ValueData: "{code:GetLicensePath}"; Check: not IsStringEmpty(ExpandConstant('{param:LICENSE_PATH}'));
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_DS_PORT}"; ValueData: "{code:GetDefaultPort}"; Check: not IsStringEmpty(ExpandConstant('{param:DS_PORT}'));
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_DOCSERVICE_PORT}"; ValueData: "{code:GetDocServicePort}"; Check: not IsStringEmpty(ExpandConstant('{param:DOCSERVICE_PORT}'));
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_FONTS_PATH}"; ValueData: "{code:GetFontsPath}"; Check: not IsStringEmpty(ExpandConstant('{param:FONTS_PATH}'));
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_JWT_ENABLED}"; ValueData: "{code:GetJwtEnabled}"; Check: not IsStringEmpty(ExpandConstant('{param:JWT_ENABLED}'));
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_JWT_SECRET}"; ValueData: "{code:GetJwtSecret}";  Check: not IsStringEmpty(ExpandConstant('{param:JWT_SECRET}'));
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_JWT_HEADER}"; ValueData: "{code:GetJwtHeader}"; Check: not IsStringEmpty(ExpandConstant('{param:JWT_HEADER}'));

[Run]
Filename: "{app}\bin\documentserver-generate-allfonts.bat"; Parameters: "true"; Flags: runhidden; StatusMsg: "{cm:GenFonts}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services===undefined)this.services={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring===undefined)this.services.CoAuthoring={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.sql===undefined)this.services.CoAuthoring.sql={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbHost = '{code:GetDbHost}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbUser = '{code:GetDbUser}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbPass = '{code:GetDbPwd}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbName = '{code:GetDbName}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.rabbitmq===undefined)this.rabbitmq={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.rabbitmq.url = '{code:GetRabbitMqProto}://{code:GetRabbitMqUser}:{code:GetRabbitMqPwd}@{code:GetRabbitMqHost}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.redis===undefined)this.services.CoAuthoring.redis={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.redis.host = '{code:GetRedisHost}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"; Check: IsCommercial;

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.server===undefined)this.services.CoAuthoring.server={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.server.port = '{code:GetDocServicePort}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.license===undefined)this.license={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.license.license_file = '{code:GetLicensePath}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.utils===undefined)this.services.CoAuthoring.utils={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.utils.utils_common_fontdir = '{code:GetFontsPath}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.token===undefined)this.services.CoAuthoring.token={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.token.enable===undefined)this.services.CoAuthoring.token.enable={{request:{{}}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.enable.browser = {code:GetJwtEnabled}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.enable.request.inbox = {code:GetJwtEnabled}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.enable.request.outbox = {code:GetJwtEnabled}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.secret===undefined)this.services.CoAuthoring.secret={{inbox:{{},outbox:{{},session: {{} };"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.secret.inbox.string = '{code:GetJwtSecret}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.secret.outbox.string = '{code:GetJwtSecret}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.secret.session.string = '{code:GetJwtSecret}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.token.inbox===undefined)this.services.CoAuthoring.token.inbox={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.inbox.header = '{code:GetJwtHeader}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.token.outbox===undefined)this.services.CoAuthoring.token.outbox={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.outbox.header = '{code:GetJwtHeader}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#REPLACE}"; Parameters: """(listen .*:)(\d{{2,5}\b)(?! ssl)(.*)"" ""$1""{code:GetDefaultPort}""$3"" ""{#NGINX_DS_CONF}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
; Filename: "{cmd}"; Parameters: "/C COPY /Y ""{#NGINX_DS_TMPL}"" ""{#NGINX_DS_CONF}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
; Filename: "{#REPLACE}"; Parameters: "{{{{DOCSERVICE_PORT}} {code:GetDocServicePort} ""{#NGINX_SRV_DIR}\conf\includes\onlyoffice-http.conf"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
; Filename: "{#REPLACE}"; Parameters: "{{{{EXAMPLE_PORT}} {code:GetExamplePort} ""{#NGINX_SRV_DIR}\conf\includes\onlyoffice-http.conf"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{app}\bin\documentserver-update-securelink.bat"; Parameters: "{param:SECURE_LINK_SECRET}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{cmd}"; Parameters: "/C icacls ""{#NGINX_SRV_DIR}"" /remove:g *S-1-5-32-545"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#PSQL}"; Parameters: "-h {code:GetDbHost} -U {code:GetDbUser} -d {code:GetDbName} -w -q -f ""{app}\server\schema\postgresql\removetbl.sql"""; Flags: runhidden; Check: IsNotClusterMode; StatusMsg: "{cm:RemoveDb}"
Filename: "{#PSQL}"; Parameters: "-h {code:GetDbHost} -U {code:GetDbUser} -d {code:GetDbName} -w -q -f ""{app}\server\schema\postgresql\createdb.sql"""; Flags: runhidden; Check: CreateDbAuth; StatusMsg: "{cm:CreateDb}"

Filename: "{#NSSM}"; Parameters: "install {#CONVERTER_SRV} ""{#CONVERTER_SRV_DIR}\converter.exe"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} DisplayName {#CONVERTER_SRV_DISPLAY}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} Description {#CONVERTER_SRV_DESCR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppDirectory {#CONVERTER_SRV_DIR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppRotateFiles 1"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppRotateOnline 1"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppRotateBytes {#LOG_ROTATE_BYTES}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppStdout {#CONVERTER_SRV_LOG_DIR}\out.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppStderr {#CONVERTER_SRV_LOG_DIR}\error.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} ObjectName ""{#LOCAL_SERVICE}"" """" "; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} Start SERVICE_DELAYED_AUTO_START"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "start {#CONVERTER_SRV}"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#CONVERTER_SRV}}"

Filename: "{#NSSM}"; Parameters: "install {#DOCSERVICE_SRV} ""{#DOCSERVICE_SRV_DIR}\docservice.exe"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} DisplayName {#DOCSERVICE_SRV_DISPLAY}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} Description {#DOCSERVICE_SRV_DESCR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppDirectory {#DOCSERVICE_SRV_DIR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppRotateFiles 1"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppRotateOnline 1"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppRotateBytes {#LOG_ROTATE_BYTES}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppStdout {#DOCSERVICE_SRV_LOG_DIR}\out.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppStderr {#DOCSERVICE_SRV_LOG_DIR}\error.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} ObjectName ""{#LOCAL_SERVICE}"" """" "; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} Start SERVICE_DELAYED_AUTO_START"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "start {#DOCSERVICE_SRV}"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#DOCSERVICE_SRV}}"

Filename: "{#NSSM}"; Parameters: "install {#NGINX_SRV} ""{#NGINX_SRV_DIR}\nginx"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} DisplayName {#NGINX_SRV_DISPLAY}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} Description {#NGINX_SRV_DESCR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} AppDirectory {#NGINX_SRV_DIR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} AppEnvironmentExtra {#NGINX_SRV_ENV}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} AppRotateFiles 1"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} AppRotateOnline 1"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} AppRotateBytes {#LOG_ROTATE_BYTES}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} AppStdout {#NGINX_SRV_LOG_DIR}\out.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} AppStderr {#NGINX_SRV_LOG_DIR}\error.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} ObjectName ""{#LOCAL_SERVICE}"" """" "; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} Start SERVICE_DELAYED_AUTO_START"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "start {#NGINX_SRV}"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#NGINX_SRV}}"

Filename: "sc"; Parameters: "failure ""{#CONVERTER_SRV}"" actions= restart/60000/restart/60000/restart/60000 reset= 86400"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "sc"; Parameters: "failure ""{#DOCSERVICE_SRV}"" actions= restart/60000/restart/60000/restart/60000 reset= 86400"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "sc"; Parameters: "failure ""{#NGINX_SRV}"" actions= restart/60000/restart/60000/restart/60000 reset= 86400"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"

Filename: "schtasks"; Parameters: "/Create /F /RU ""{#LOCAL_SERVICE}"" /SC DAILY /TN ""{#LogRotateTaskName}"" /TR ""{app}\bin\documentserver-log-rotate.bat"""; Flags: runhidden; StatusMsg: "{cm:AddRotateTask}"

Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""{#NGINX_SRV_DESCR}"" program=""{#NGINX_SRV_DIR}\nginx.exe"" dir=in action=allow protocol=tcp localport={code:GetDefaultPorts}"; Flags: runhidden; StatusMsg: "{cm:FireWallExt}"

[UninstallRun]
Filename: "{app}\bin\documentserver-prepare4shutdown.bat"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#NGINX_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#NGINX_SRV} confirm"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#CONVERTER_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#CONVERTER_SRV} confirm"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#DOCSERVICE_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#DOCSERVICE_SRV} confirm"; Flags: runhidden

Filename: "schtasks"; Parameters: "/End /TN ""{#LogRotateTaskName}"""; Flags: runhidden
Filename: "schtasks"; Parameters: "/Delete /F /TN ""{#LogRotateTaskName}"""; Flags: runhidden

Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""{#NGINX_SRV_DESCR}"""; Flags: runhidden; StatusMsg: "{cm:FireWallExt}"

[UninstallDelete]
Type: filesandordirs; Name: "{app}\sdkjs"
Type: filesandordirs; Name: "{app}\fonts"
Type: files; Name: "{app}\server\FileConverter\bin\font_selection.bin"
Type: files; Name: "{app}\server\FileConverter\bin\AllFonts.js"

[Types]
Name: full; Description: {cm:FullInstall}
Name: compact; Description: {cm:CompactInstall}
Name: custom; Description: {cm:CustomInstall}; Flags: iscustom
 

[Components]
Name: "Program"; Description: "{cm:Program}"; Types: full compact custom; Flags: fixed
Name: "Prerequisites"; Description: "{cm:Prerequisites}"; Types: full
Name: "Prerequisites\RabbitMq"; Description: "RabbitMQ 3.8"; Flags: checkablealone; Types: full; 
Name: "Prerequisites\Redis"; Description: "Redis 3"; Flags: checkablealone; Types: full;
Name: "Prerequisites\PostgreSQL"; Description: "PostgreSQL 10.2"; Flags: checkablealone; Types: full; 

[Code]
function UninstallPreviosVersion(): Boolean;
var
  UninstallerPath: String;
  UninstallRegKey: String;
  UninstallerParam: String;
  ResultCode: Integer;
  ConfirmUninstall: Integer;
begin
  Result := True;
  UninstallerParam := '/VERYSILENT';
  UninstallRegKey := '{reg:HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#sAppId}_is1,UninstallString}';

  UninstallerPath := RemoveQuotes(ExpandConstant(UninstallRegKey));
  if Length(UninstallerPath) > 0 then begin
    ConfirmUninstall := IDOK;

    if not WizardSilent() then begin
      UninstallerParam := '/SILENT';
      ConfirmUninstall := MsgBox(
                              ExpandConstant('{cm:PrevVer}'),
                              mbConfirmation,
                              MB_OKCANCEL);
    end;

    if ConfirmUninstall = IDOK then begin
      Exec(
        UninstallerPath,
        UninstallerParam,
        '', 
        SW_HIDE,
        ewWaitUntilTerminated,
        ResultCode);
      
      while FileExists( UninstallerPath ) do begin
        Sleep(500);
      end

    end else begin
      Result := False;
    end;
  end;
end;

function ExtractFiles(): Boolean;
begin
  ExtractTemporaryFile('connectionRabbit.py');
  ExtractTemporaryFile('psql.exe');
  ExtractTemporaryFile('libintl-8.dll');
  ExtractTemporaryFile('libpq.dll');
  ExtractTemporaryFile('libcrypto-1_1-x64.dll');
  ExtractTemporaryFile('libssl-1_1-x64.dll');
  ExtractTemporaryFile('libiconv-2.dll')
end;

function InitializeSetup(): Boolean;
begin
 
  ExtractFiles();
  
  if not UninstallPreviosVersion() then
  begin
    Abort();
  end;
 
  if WizardSilent() = false then
  begin
    Dependency_AddVC2013;
    Dependency_AddVC2015To2022;
    Dependency_AddPython3;
  end;

  Result := true;
end;

var
  DbPage: TInputQueryWizardPage;
  RabbitMqPage: TInputQueryWizardPage;
  RedisPage: TInputQueryWizardPage;

function GetDbHost(Param: String): String;
begin
  Result := DbPage.Values[0];
end;

function GetDbPort(Param: String): String;
begin
  Result := IntToStr(5432);
end;

function GetDbUser(Param: String): String;
begin
  Result := DbPage.Values[1];
end;

function GetDbPwd(Param: String): String;
begin
  Result := DbPage.Values[2];
end;

function GetDbName(Param: String): String;
begin
  Result := DbPage.Values[3];
end;

function GetRabbitMqHost(Param: String): String;
begin
  Result := RabbitMqPage.Values[0];
end;

function GetRabbitMqUser(Param: String): String;
begin
  Result := RabbitMqPage.Values[1];
end;

function GetRabbitMqPwd(Param: String): String;
begin
  Result := RabbitMqPage.Values[2];
end;

function GetRabbitMqProto(Param: String): String;
begin
  Result := RabbitMqPage.Values[3];
end;

function GetRedisHost(Param: String): String;
begin
  Result := RedisPage.Values[0];
end;

function GetDefaultPort(Param: String): String;
begin
  Result := ExpandConstant('{param:DS_PORT|{reg:HKLM\{#sAppRegPath},{#REG_DS_PORT}|80}}');
end;

function GetDefaultPorts(Param: String): String;
begin
  Result := GetDefaultPort('');
  if (Result = '80') then begin
    Result := Result + ',' + '443';
  end;
end;

function GetDocServicePort(Param: String): String;
begin
  Result := ExpandConstant('{param:DOCSERVICE_PORT|{reg:HKLM\{#sAppRegPath},{#REG_DOCSERVICE_PORT}|8000}}');
end;

function GetExamplePort(Param: String): String;
begin
  Result := ExpandConstant('{param:EXAMPLE_PORT|{reg:HKLM\{#sAppRegPath},{#REG_EXAMPLE_PORT}|3000}}');
end;

function GetLicensePath(Param: String): String;
var
  LicensePath: String;
begin
  LicensePath := ExpandConstant('{param:LICENSE_PATH|{reg:HKLM\{#sAppRegPath},{#REG_LICENSE_PATH}|{#LICENSE_PATH}\license.lic}}');
  StringChangeEx(LicensePath, '\', '/', True);
  Result := LicensePath;
end;

function GetFontsPath(Param: String): String;
var
  FontPath: String;
begin
  FontPath := ExpandConstant('{param:FONTS_PATH|{reg:HKLM\{#sAppRegPath},{#REG_FONTS_PATH}|{fonts}}}');
  StringChangeEx(FontPath, '\', '/', True);
  Result := FontPath;
end;

function GetJwtEnabled(Param: String): String;
begin
  Result := ExpandConstant('{param:JWT_ENABLED|{reg:HKLM\{#sAppRegPath},{#REG_JWT_ENABLED}|false}}');
end;

function GetJwtSecret(Param: String): String;
begin
  Result := ExpandConstant('{param:JWT_SECRET|{reg:HKLM\{#sAppRegPath},{#REG_JWT_SECRET}|secret}}');
end;

function GetJwtHeader(Param: String): String;
begin
  Result := ExpandConstant('{param:JWT_HEADER|{reg:HKLM\{#sAppRegPath},{#REG_JWT_HEADER}|Authorization}}');
end;

function IsCommercial: Boolean;
begin
  Result := false;
  if ('{#sProductName}' = 'DocumentServer-EE') or ('{#sProductName}' = 'DocumentServer-IE') or ('{#sProductName}' = 'DocumentServer-DE') then begin
    Result := true;
  end;
end;

procedure InitializeWizard;
begin
  DbPage := CreateInputQueryPage(
    wpPreparing,
    ExpandConstant('{cm:Postgre}'),
    FmtMessage(ExpandConstant('{cm:PackageConfigure}'), ['{#PostgreSQL}' + '...']),
    FmtMessage(ExpandConstant('{cm:PackageConnection}'), ['{#PostgreSQL}']));
  DbPage.Add(ExpandConstant('{cm:Host}'), False);
  DbPage.Add(ExpandConstant('{cm:User}'), False);
  DbPage.Add(ExpandConstant('{cm:Password}'), True);
  DbPage.Add(ExpandConstant('{cm:PostgreDb}'), False);

  DbPage.Values[0] := ExpandConstant('{param:DB_HOST|{reg:HKLM\{#sAppRegPath},{#REG_DB_HOST}|localhost}}');
  DbPage.Values[1] := ExpandConstant('{param:DB_USER|{reg:HKLM\{#sAppRegPath},{#REG_DB_USER}|{#sDbDefValue}}}');
  DbPage.Values[2] := ExpandConstant('{param:DB_PWD|{reg:HKLM\{#sAppRegPath},{#REG_DB_PWD}|{#sDbDefValue}}}');
  DbPage.Values[3] := ExpandConstant('{param:DB_NAME|{reg:HKLM\{#sAppRegPath},{#REG_DB_NAME}|{#sDbDefValue}}}');

  RabbitMqPage := CreateInputQueryPage(
    DbPage.ID,
    ExpandConstant('{cm:RabbitMq}'),
    FmtMessage(ExpandConstant('{cm:PackageConfigure}'), ['{#RabbitMQ}' + '...']),
    FmtMessage(ExpandConstant('{cm:PackageConnection}'), ['{#RabbitMQ}']));
  RabbitMqPage.Add(ExpandConstant('{cm:Host}'), False);
  RabbitMqPage.Add(ExpandConstant('{cm:User}'), False);
  RabbitMqPage.Add(ExpandConstant('{cm:Password}'), True);
  RabbitMqPage.Add(ExpandConstant('{cm:Protocol}'), False);
  
  RabbitMqPage.Values[0] := ExpandConstant('{param:RABBITMQ_HOST|{reg:HKLM\{#sAppRegPath},{#REG_RABBITMQ_HOST}|localhost}}');
  RabbitMqPage.Values[1] := ExpandConstant('{param:RABBITMQ_USER|{reg:HKLM\{#sAppRegPath},{#REG_RABBITMQ_USER}|guest}}');
  RabbitMqPage.Values[2] := ExpandConstant('{param:RABBITMQ_PWD|{reg:HKLM\{#sAppRegPath},{#REG_RABBITMQ_PWD}|guest}}');
  RabbitMqPage.Values[3] := ExpandConstant('{param:RABBITMQ_PROTO|{reg:HKLM\{#sAppRegPath},{#REG_RABBITMQ_PROTO}|amqp}}');
  
  if IsCommercial then begin
    RedisPage := CreateInputQueryPage(
      RabbitMqPage.ID,
      ExpandConstant('{cm:Redis}'),
      FmtMessage(ExpandConstant('{cm:PackageConfigure}'), ['{#Redis}' + '...']),
      FmtMessage(ExpandConstant('{cm:PackageConnection}'), ['{#Redis}']));
    RedisPage.Add(ExpandConstant('{cm:Host}'), False);

    RedisPage.Values[0] := ExpandConstant('{param:REDIS_HOST|{reg:HKLM\{#sAppRegPath},{#REG_REDIS_HOST}|localhost}}');
  end;

end;

function CreateDbAuth(): Boolean;
begin
  Result := true;

  SaveStringToFile(
    ExpandConstant('{#POSTGRESQL_DATA_DIR}\pgpass.conf'),
    GetDbHost('')+ ':' + GetDbPort('')+ ':' + GetDbName('') + ':' + GetDbUser('') + ':' + GetDbPwd(''),
    False);
end;

function IsNotClusterMode(): Boolean;
var
  ClusterMode: Integer;
begin
  Result := true;
  ClusterMode := StrToInt(ExpandConstant('{param:CLUSTER_MODE|0}'));
  if ClusterMode > 0 then
  begin
    Result := false;
  end;
  CreateDbAuth();
end;

function IsStringEmpty(Param: String): Boolean;
begin
  Result := false;
  if Length(Param) <= 0 then
  begin
    Result := true;
  end;
end;

function CheckDbConnection(): Boolean;
var
  ResultCode: Integer;
begin
  Result := true;

  SaveStringToFile(
    ExpandConstant('{userappdata}\postgresql\pgpass.conf'),
    GetDbHost('')+ ':' + GetDbPort('')+ ':' + GetDbName('') + ':' + GetDbUser('') + ':' + GetDbPwd(''),
    False);

  Exec(
    ExpandConstant('{tmp}\psql.exe'),
    '-h ' + GetDbHost('') + ' -U ' + GetDbUser('') + ' -d ' + GetDbName('') + ' -w -c ";"',
    '',
    SW_SHOW,
    EwWaitUntilTerminated,
    ResultCode);

  if ResultCode <> 0 then
  begin
    MsgBox(
      FmtMessage(
        ExpandConstant('{cm:CheckConnection}'),
        ([GetDbHost(''), 'PSQL', IntToStr(ResultCode) + '.'])),
      mbError,
      MB_OK);
    Result := false;
  end;
end;

function CheckRabbitMqConnection(): Boolean;
var
  ResultCode: Integer;
begin
  Result := true;

  ShellExec(
    '',
    ExpandConstant('{#Python}'),
    '--version',
    '',
    SW_SHOW,
    EwWaitUntilTerminated,
    ResultCode);

  if ResultCode <> 0 then
  begin
    MsgBox(
      FmtMessage(ExpandConstant('{cm:NotAvailable}'), ['Python ']) +
      FmtMessage(ExpandConstant('{cm:SkipValidation}'), ['{#RabbitMQ}']),
      mbInformation,
      MB_OK);
    Exit;
  end;

  if DirExists(ExpandConstant('{sd}') + '\Python\Lib\site-packages\pika') = false then
  begin
    Exec(
    ExpandConstant('{sd}') + '\Python\scripts\pip.exe',
    'install pika',
    '',
    SW_SHOW,
    EwWaitUntilTerminated,
    ResultCode);
  end;

  if FileExists(ExpandConstant('{tmp}\connectionRabbit.py')) = true then
  begin
    ShellExec(
      '',
      ExpandConstant('{#Python}'),
      (ExpandConstant('{tmp}\connectionRabbit.py') + ' ' +
      GetRabbitMqUser('') + ' ' +
      GetRabbitMqPwd('') + ' ' +
      GetRabbitMqHost('')),
      '',
      SW_SHOW,
      EwWaitUntilTerminated,
      ResultCode);
  end
  else
  begin 
    MsgBox(
      ExpandConstant('{cm:CheckFailed}') + ' ' +
      FmtMessage(ExpandConstant('{cm:SkipValidation}'), ['{#RabbitMQ}']),
      mbInformation,
      MB_OK);
    Exit;
  end;

  if ResultCode <> 0 then
  begin
    MsgBox(
      FmtMessage(
        ExpandConstant('{cm:CheckConnection}'),
        ([GetRabbitMqHost(''), '{#RabbitMQ}', IntToStr(ResultCode) + '.'])),
      mbError,
      MB_OK);
    Result := false;
  end;
end;

function CheckRedisConnection(): Boolean;
var
  ResultCode: Integer;
begin
  Result := true;

  if DirExists(ExpandConstant('{sd}') + '\Python\Lib\site-packages\iredis') = false then
  begin
    Exec(
    ExpandConstant('{sd}') + '\Python\scripts\pip.exe',
    'install iredis',
    '',
    SW_SHOW,
    EwWaitUntilTerminated,
    ResultCode);
  end;

  Exec(
    '>',
    'iredis -h ' + GetRedisHost('') + ' quit',
    '',
    SW_SHOW,
    EwWaitUntilTerminated,
    ResultCode);

  if ResultCode <> 0 then
  begin
    MsgBox(
      FmtMessage(
        ExpandConstant('{cm:CheckConnection}'),
        ([GetRedisHost(''), '{#Redis}', IntToStr(ResultCode) + '.'])),
      mbError,
      MB_OK);
    Result := false;
  end;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := false;
  case PageID of
    DbPage.ID:
      Result := not IsComponentSelected('Prerequisites\PostgreSQL');
    RabbitMqPage.ID:
      Result := not IsComponentSelected('Prerequisites\RabbitMq');
    RedisPage.ID:
      Result := not IsComponentSelected('Prerequisites\Redis');
  end;
end;

function ArrayLength(a: array of integer): Integer;
begin
  Result := GetArrayLength(a);
end;

function CheckPortOccupied(): Boolean;
var
  ResultCode: Integer;
  I: Integer;
  Ports: Array[0..2] of Integer;
begin
  if WizardSilent() = false then
  begin
    Result := true;
    Ports[0] := StrToInt(GetDefaultPort(''));
    Ports[1] := 8080;
    Ports[2] := 3000;
    for I := 0 to ArrayLength(Ports) - 1 do
    begin
      Exec(
        ExpandConstant('{cmd}'),
        '/C netstat -na | findstr'+' /C:":' + IntToStr(Ports[I]) + ' "',
        '',
        0,
        ewWaitUntilTerminated,
        ResultCode);
      if ResultCode <> 1 then
      begin
        MsgBox(
          FmtMessage(
            ExpandConstant('{cm:UsePort}'), [IntToStr(Ports[I])]),
          mbInformation,
          MB_OK);
        Result := true; 
      end
    end;
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := true;
  if WizardSilent() = false then
  begin
    case CurPageID of
      DbPage.ID:
        Result := CheckDbConnection();
      RabbitMqPage.ID:
        Result := CheckRabbitMqConnection();
      RedisPage.ID:
        Result := CheckRedisConnection();
      wpWelcome:
        Result := CheckPortOccupied();
      wpSelectComponents:
      begin
        if IsComponentSelected('Prerequisites\Redis') then
        begin
          Dependency_AddRedis;
        end;
        if IsComponentSelected('Prerequisites\RabbitMq') then
        begin
          Dependency_AddErlang;
          Dependency_AddRabbitMq;
        end;
        if not IsComponentSelected('Prerequisites\PostgreSQL') then
        begin
          Dependency_AddPostgreSQL;
        end;
      end;
    end;
  end;
end;

