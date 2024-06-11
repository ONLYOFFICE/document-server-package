; -- Docs Installer --

#ifndef EDITION
#define EDITION 'community'
#endif

#ifndef VERSION
#define VERSION '0.0.0.0'
#endif

#ifndef BRANDING_DIR
#define BRANDING_DIR '.'
#endif

#include BRANDING_DIR + '\defines.iss'

#ifndef sPackageName
#define sPackageName sIntCompanyName + '-' + sIntProductName
#if SameText(EDITION, 'developer') | SameText(EDITION, 'enterprise')
#define sPackageName sPackageName + '-' + UpperCase(Copy(EDITION,1,1)) + 'E'
#endif
#endif

#define iconsExe              'projicons.exe'

#define REG_LICENSE_PATH      'LicensePath'
#define REG_DB_HOST           'DbHost'
#define REG_DB_PORT           'DbPort'
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

#ifndef sDbDefValue
  #define sDbDefValue         'onlyoffice'
#endif

#define DefHost               'localhost'

#define DbDefName              sDbDefValue
#define DbDefUser              sDbDefValue
#define DbDefPort              '5432'

#define DbHost                 DefHost
#define DbAdminUserName        'postgres'
#define DbAdminName            'postgres'
#define DbAdminPassword        'postgres'

#define AmqpServerHost         DefHost
#define AmqpServerUserName     'guest'
#define AmqpServerPassword     'guest'
#define AmqpServerProto        'amqp'

#define RedisHost              DefHost

#define WINSW                 '{app}\winsw\WinSW-x64.exe'

#define LOCAL_SERVICE 'NT Authority\LocalService'

#define CONVERTER_SRV        'DsConverterSvc'
#define CONVERTER_SRV_DISPLAY  str(sAppName + " Converter")
#define CONVERTER_SRV_DESCR  str(sAppName + " Converter Service")
#define CONVERTER_SRV_DIR    '{app}\server\FileConverter'
#define CONVERTER_SRV_LOG_DIR    '{app}\Log\converter'
#define CONVERTER_SRV_FILE '{app}\winsw\Converter.xml'

#define DOCSERVICE_SRV        'DsDocServiceSvc'
#define DOCSERVICE_SRV_DISPLAY  str(sAppName + " DocService")
#define DOCSERVICE_SRV_DESCR  str(sAppName + " DocService Service")
#define DOCSERVICE_SRV_DIR    '{app}\server\docservice'
#define DOCSERVICE_SRV_LOG_DIR    '{app}\Log\docservice'
#define DOCSERVICE_SRV_FILE '{app}\winsw\DocService.xml'

#define PSQL '{app}\pgsql\bin\psql.exe'
#define POSTGRESQL_DATA_DIR '{userappdata}\postgresql'

#define JSON '{app}\npm\json.exe'

#define JSON_PARAMS '-I -q -f ""{app}\config\local.json""'

#define LOCAL_DATA_STORAGE   'editorDataMemory'

#define REPLACE '{app}\npm\replace.exe'

#define DEFAULT_PLUGINS_LIST '{app}\sdkjs-plugins\plugin-list-default.json'

#define PROXY_SRV_FILE '{app}\winsw\Proxy.xml'
#define NGINX_SRV  'DsProxySvc'
#define NGINX_SRV_DISPLAY  str(sAppName + " Proxy")
#define NGINX_SRV_DESCR  str(sAppName + " Proxy Service")
#define NGINX_SRV_DIR  '{app}\nginx'
#define NGINX_SRV_LOG_DIR    '{app}\Log\nginx'
#define NGINX_DS_CONF '{app}\nginx\conf\ds.conf'
#define NGINX_DS_TMPL '{app}\nginx\conf\ds.conf.tmpl'
#define NGINX_DS_SSL_TMPL '{app}\nginx\conf\ds-ssl.conf.tmpl'

#define LICENSE_PATH str("{commonappdata}\" + sIntCompanyName + "\Data")

#define LogRotateTaskName str(sAppName + " Log Rotate Task")
#define LOG_ROTATE_BYTES 10485760

#define PythonPath '{sd}\Python'
#define Python str(PythonPath + "\python.exe")
#define Pip str(PythonPath + "\scripts\pip.exe")
#define RabbitMq 'RabbitMQ'
#define PostgreSQL 'PostgreSQL'
#define Redis 'Redis'
#define OpenSslPath '{pf}\FireDaemon OpenSSL 3\bin'

#define public Dependency_NoExampleSetup
#include "InnoDependencyInstaller\CodeDependencies.iss"
#include "products.iss"

[Setup]
AppName                   ={#sAppName}
AppId                     ={#sAppId}
AppVerName                ={#sAppName} {#Copy(VERSION,1,RPos('.',VERSION)-1)}
AppVersion                ={#VERSION}
VersionInfoVersion        ={#VERSION}
OutputBaseFilename        ={#sPackageName}-{#VERSION}-x64

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

WizardSizePercent         = 110
UsePreviousAppDir         = yes
DirExistsWarning          =no
DefaultDirName            ={commonpf}\{#sAppPath}
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
MinVersion                =6.1sp1
WizardImageFile           ={#BRANDING_DIR}\data\dialogpicture.bmp
WizardSmallImageFile      ={#BRANDING_DIR}\data\dialogicon.bmp
SetupIconFile             ={#BRANDING_DIR}\data\icon.ico
#if SameText(sIntCompanyName, 'onlyoffice')
LicenseFile               ={#BRANDING_DIR}\license\{#EDITION}\LICENSE.rtf
#endif
ShowLanguageDialog        = no
MissingRunOnceIdsWarning  = no
UsedUserAreasWarning      = no

#ifdef SIGN
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

en.InstallPlugins=Installing plugins ...
ru.InstallPlugins=Установка плагинов ...

en.PrevVer=The previous version of {#sAppName} detected, please click 'OK' button to uninstall it, or 'Cancel' to quit setup.
ru.PrevVer=Обнаружена предыдущая версия {#sAppName}, нажмите кнопку 'OK' чтобы удалить её, или 'Отмена' чтобы выйти из программы инсталляции.

en.EnableJWT=JWT is enabled by default. A random secret is generated automatically. The secret is available in %ProgramFiles%\{#sAppPath}\config\local.json, in services.CoAuthoring.secret.inbox.string parameter.
ru.EnableJWT=JWT включен по умолчанию. Случайный секрет генерируется автоматически. Секрет доступен в %ProgramFiles%\{#sAppPath}\config\local.json, параметр services.CoAuthoring.secret.inbox.string

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

en.CustomInstall=Custom installation
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
Source: ..\common\documentserver\home\*;            DestDir: {app}; Excludes: "*local.json"; Flags: ignoreversion recursesubdirs; Components: Program
Source: ..\common\documentserver\config\*;          DestDir: {app}\config; Flags: ignoreversion recursesubdirs; Permissions: users-readexec; Components: Program
Source: local\local.json;                           DestDir: {app}\config; Flags: onlyifdoesntexist uninsneveruninstall; Components: Program
Source: ..\common\documentserver\bin\*.bat;         DestDir: {app}\bin; Excludes: "documentserver-pluginsmanager.bat"; Flags: ignoreversion recursesubdirs; Components: Program
#ifdef DS_PLUGIN_INSTALLATION
Source: ..\common\documentserver\bin\documentserver-pluginsmanager.bat;    DestDir: {app}\bin; Flags: ignoreversion recursesubdirs; Components: Program
#endif
Source: ..\common\documentserver\bin\*.ps1;         DestDir: {app}\bin; Flags: ignoreversion recursesubdirs; Components: Program
Source: nginx\nginx.conf;                           DestDir: {#NGINX_SRV_DIR}\conf; Flags: ignoreversion recursesubdirs; Components: Program
Source: ..\common\documentserver\nginx\includes\*.conf;  DestDir: {#NGINX_SRV_DIR}\conf\includes; Flags: ignoreversion recursesubdirs; Components: Program
Source: ..\common\documentserver\nginx\*.tmpl;  DestDir: {#NGINX_SRV_DIR}\conf; Flags: ignoreversion recursesubdirs; Components: Program
Source: ..\common\documentserver\nginx\ds.conf; DestDir: {#NGINX_SRV_DIR}\conf; Flags: onlyifdoesntexist uninsneveruninstall; Components: Program
Source: scripts\connectionRabbit.py;            DestDir: "{app}"; Flags: ignoreversion; Components: Program
Source: winsw\WinSW-x64.exe;                    DestDir: "{app}\winsw"; Flags: ignoreversion; Components: Program
Source: {#file "winsw\Converter.xml"};          DestDir: "{app}\winsw"; Flags: ignoreversion; DestName: "Converter.xml"
Source: {#file "winsw\DocService.xml"};         DestDir: "{app}\winsw"; Flags: ignoreversion; DestName: "DocService.xml"
Source: {#file "winsw\Proxy.xml"};              DestDir: "{app}\winsw"; Flags: ignoreversion; DestName: "Proxy.xml"

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
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_DB_PORT}"; ValueData: "{code:GetDbPort}";
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

#ifdef DS_PLUGIN_INSTALLATION
Filename: "{app}\bin\documentserver-pluginsmanager.bat"; Parameters: "-r false --update ""{#DEFAULT_PLUGINS_LIST}"""; Flags: runhidden; StatusMsg: "{cm:InstallPlugins}"
#endif

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services===undefined)this.services={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring===undefined)this.services.CoAuthoring={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.sql===undefined)this.services.CoAuthoring.sql={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbHost = '{code:GetDbHost}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbPort = '{code:GetDbPort}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbUser = '{code:GetDbUser}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbPass = '{code:GetDbPwd}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbName = '{code:GetDbName}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.rabbitmq===undefined)this.rabbitmq={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.rabbitmq.url = '{code:GetRabbitMqProto}://{code:GetRabbitMqUser}:{code:GetRabbitMqPwd}@{code:GetRabbitMqHost}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.redis===undefined)this.services.CoAuthoring.redis={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.redis.host = '{code:GetRedisHost}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"; Check: IsCommercial;

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.server===undefined)this.services.CoAuthoring.server={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.server.port = '{code:GetDocServicePort}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.server.editorDataStorage = '{#LOCAL_DATA_STORAGE}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"; Check: UseLocalStorage;

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.license===undefined)this.license={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.license.license_file = '{code:GetLicensePath}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.utils===undefined)this.services.CoAuthoring.utils={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.utils.utils_common_fontdir = '{code:GetFontsPath}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.token===undefined)this.services.CoAuthoring.token={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.token.enable===undefined)this.services.CoAuthoring.token.enable={{request:{{}}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.enable.browser = {code:GetJwtEnabled}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"; Check: (not IsLocalJsonExists()) or (not IsStringEmpty(ExpandConstant('{param:JWT_ENABLED}')));
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.enable.request.inbox = {code:GetJwtEnabled}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"; Check: (not IsLocalJsonExists()) or (not IsStringEmpty(ExpandConstant('{param:JWT_ENABLED}')));
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.enable.request.outbox = {code:GetJwtEnabled}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"; Check: (not IsLocalJsonExists()) or (not IsStringEmpty(ExpandConstant('{param:JWT_ENABLED}')));

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.secret===undefined)this.services.CoAuthoring.secret={{inbox:{{},outbox:{{},session: {{} };"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.secret.inbox.string = '{code:GetJwtSecret}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"; Check: (not IsLocalJsonExists()) or (not IsStringEmpty(ExpandConstant('{param:JWT_SECRET}')));
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.secret.outbox.string = '{code:GetJwtSecret}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"; Check: (not IsLocalJsonExists()) or (not IsStringEmpty(ExpandConstant('{param:JWT_SECRET}')));
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.secret.session.string = '{code:GetJwtSecret}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"; Check: (not IsLocalJsonExists()) or (not IsStringEmpty(ExpandConstant('{param:JWT_SECRET}')));

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.token.inbox===undefined)this.services.CoAuthoring.token.inbox={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.inbox.header = '{code:GetJwtHeader}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"; Check: (not IsLocalJsonExists()) or (not IsStringEmpty(ExpandConstant('{param:JWT_HEADER}')));

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.token.outbox===undefined)this.services.CoAuthoring.token.outbox={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.outbox.header = '{code:GetJwtHeader}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"; Check: (not IsLocalJsonExists()) or (not IsStringEmpty(ExpandConstant('{param:JWT_HEADER}')));

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.wopi===undefined)this.wopi={{};"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"; Check: GenerateRSAKey;
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.wopi.enable = {code:GetWopiEnabled}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}";
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.wopi.privateKey = '{code:GetWopiPrivateKey}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}";
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.wopi.privateKeyOld = '{code:GetWopiPrivateKey}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}";
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.wopi.publicKey = '{code:GetWopiPublicKey}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}";
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.wopi.publicKeyOld = '{code:GetWopiPublicKey}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}";
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.wopi.modulus = '{code:GetWopiModulus}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}";
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.wopi.modulusOld = '{code:GetWopiModulus}'"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}";
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.wopi.exponent = {code:GetWopiExponent}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}";
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.wopi.exponentOld = {code:GetWopiExponent}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}";

Filename: "{#REPLACE}"; Parameters: """(listen .*:)(\d{{2,5}\b)(?! ssl)(.*)"" ""$1""{code:GetDefaultPort}""$3"" ""{#NGINX_DS_CONF}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
; Filename: "{cmd}"; Parameters: "/C COPY /Y ""{#NGINX_DS_TMPL}"" ""{#NGINX_DS_CONF}"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
; Filename: "{#REPLACE}"; Parameters: "{{{{DOCSERVICE_PORT}} {code:GetDocServicePort} ""{#NGINX_SRV_DIR}\conf\includes\onlyoffice-http.conf"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
; Filename: "{#REPLACE}"; Parameters: "{{{{EXAMPLE_PORT}} {code:GetExamplePort} ""{#NGINX_SRV_DIR}\conf\includes\onlyoffice-http.conf"""; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{app}\bin\documentserver-update-securelink.bat"; Parameters: "{param:SECURE_LINK_SECRET}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{cmd}"; Parameters: "/C icacls ""{#NGINX_SRV_DIR}"" /remove:g *S-1-5-32-545"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#PSQL}"; Parameters: "-U {#DbAdminUserName} -w -q -c ""CREATE USER {#DbDefUser} WITH PASSWORD '{code:GetDbPwd}';"""; Flags: runhidden; Check: WizardIsComponentSelected('Prerequisites\PostgreSQL') and CreateDbDefUserAuth;
Filename: "{#PSQL}"; Parameters: "-U {#DbAdminUserName} -w -q -c ""CREATE DATABASE {#DbDefName};"""; Flags: runhidden; Check: WizardIsComponentSelected('Prerequisites\PostgreSQL');
Filename: "{#PSQL}"; Parameters: "-U {#DbAdminUserName} -w -q -c ""GRANT ALL PRIVILEGES ON DATABASE {#DbDefName}  TO {#DbDefUser};"""; Flags: runhidden; Check: WizardIsComponentSelected('Prerequisites\PostgreSQL');

Filename: "{#PSQL}"; Parameters: "-h {code:GetDbHost} -U {code:GetDbUser} -d {code:GetDbName} -p {code:GetDbPort} -w -q -f ""{app}\server\schema\postgresql\removetbl.sql"""; Flags: runhidden; Check: IsNotClusterMode; StatusMsg: "{cm:RemoveDb}"
Filename: "{#PSQL}"; Parameters: "-h {code:GetDbHost} -U {code:GetDbUser} -d {code:GetDbName} -p {code:GetDbPort} -w -q -f ""{app}\server\schema\postgresql\createdb.sql"""; Flags: runhidden; Check: CreateDbAuth; StatusMsg: "{cm:CreateDb}"

Filename: "{#WINSW}";   Parameters: "install ""{#CONVERTER_SRV_FILE}"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#CONVERTER_SRV}}"
Filename: "{#WINSW}";   Parameters: "start ""{#CONVERTER_SRV_FILE}"""; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#CONVERTER_SRV}}"

Filename: "{#WINSW}";   Parameters: "install ""{#DOCSERVICE_SRV_FILE}"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#DOCSERVICE_SRV}}"
Filename: "{#WINSW}";   Parameters: "start ""{#DOCSERVICE_SRV_FILE}"""; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#DOCSERVICE_SRV}}"

Filename: "{#WINSW}";   Parameters: "install ""{#PROXY_SRV_FILE}"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#NGINX_SRV}}"
Filename: "{#WINSW}";   Parameters: "start ""{#PROXY_SRV_FILE}"""; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#NGINX_SRV}}"

Filename: "sc"; Parameters: "failure ""{#CONVERTER_SRV}"" actions= restart/60000/restart/60000/restart/60000 reset= 86400"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "sc"; Parameters: "failure ""{#DOCSERVICE_SRV}"" actions= restart/60000/restart/60000/restart/60000 reset= 86400"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "sc"; Parameters: "failure ""{#NGINX_SRV}"" actions= restart/60000/restart/60000/restart/60000 reset= 86400"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"

Filename: "schtasks"; Parameters: "/Create /F /RU ""{#LOCAL_SERVICE}"" /SC DAILY /TN ""{#LogRotateTaskName}"" /TR ""{app}\bin\documentserver-log-rotate.bat"""; Flags: runhidden; StatusMsg: "{cm:AddRotateTask}"

Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""{#NGINX_SRV_DESCR}"" program=""{#NGINX_SRV_DIR}\nginx.exe"" dir=in action=allow protocol=tcp localport={code:GetDefaultPorts}"; Flags: runhidden; StatusMsg: "{cm:FireWallExt}"

[UninstallRun]
Filename: "{app}\bin\documentserver-prepare4shutdown.bat"; Flags: runhidden

Filename: "{#WINSW}"; Parameters: "stop ""{#PROXY_SRV_FILE}"""; Flags: runhidden
Filename: "{#WINSW}"; Parameters: "uninstall ""{#PROXY_SRV_FILE}"""; Flags: runhidden

Filename: "{#WINSW}"; Parameters: "stop ""{#CONVERTER_SRV_FILE}"""; Flags: runhidden
Filename: "{#WINSW}"; Parameters: "uninstall ""{#CONVERTER_SRV_FILE}"""; Flags: runhidden

Filename: "{#WINSW}"; Parameters: "stop ""{#DOCSERVICE_SRV_FILE}"""; Flags: runhidden
Filename: "{#WINSW}"; Parameters: "uninstall ""{#DOCSERVICE_SRV_FILE}"""; Flags: runhidden

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
Name: "Prerequisites\Certbot"; Description: "Certbot"; Flags: checkablealone; Types: full; Check: not IsCertbotInstalled;
Name: "Prerequisites\OpenSSL"; Description: "OpenSSL"; Flags: fixed; Types: full custom compact; Check: not IsOpenSSLInstalled;
Name: "Prerequisites\Python"; Description: "Python 3.11.3 "; Flags: checkablealone; Types: full; Check: not IsPythonInstalled;
Name: "Prerequisites\PostgreSQL"; Description: "PostgreSQL 12.17"; Flags: checkablealone; Types: full; Check: not IsPostgreSQLInstalled;
Name: "Prerequisites\RabbitMq"; Description: "RabbitMQ 3.12.11"; Flags: checkablealone; Types: full; Check: not IsRabbitMQInstalled;
Name: "Prerequisites\Redis"; Description: "Redis 5.0.10"; Flags: checkablealone; Types: full; Check: IsCommercial and not IsRedisInstalled and not UseLocalStorage;

[Code]
var
  JWTSecret: String;
  IsJWTRegistryExists: Boolean;
  LocalJsonExists: Boolean;
  AmqpServerHost: String;
  AmqpServerUserName: String;
  AmqpServerPassword: String;
  AmqpServerProto: String;
  DbUserName: String;
  DbName: String;
  DbPassword: String;
  DbHost: String;
  DbPort: String;
  RedisHost: String;
  WopiEnabled: String;
  WopiPrivateKey: String;
  WopiPublicKey: String;
  WopiModulus: String;
  WopiExponent: String;

function GetRandomDbPwd: String; forward;

procedure InitAmqpServerParams(Host, UserName, Password, Proto: String);
begin
  AmqpServerHost := Host;
  AmqpServerUserName := UserName;
  AmqpServerPassword := Password;
  AmqpServerProto := Proto;
end;

procedure InitDbParams(Host, Port, UserName, Password, Name: String);
begin
  DbHost := Host;
  DbPort := Port;
  DbUserName := UserName;
  DbPassword := Password;
  DbName := Name;
end;

procedure InitRedisParams(Host: String);
begin
  RedisHost := Host;
end;

procedure InitWopiEnabled(Enabled: String);
begin
  WopiEnabled := Enabled;
end;

procedure Init;
begin
  IsJWTRegistryExists := False;
  LocalJsonExists := False;

  InitAmqpServerParams(
    ExpandConstant('{param:RABBITMQ_HOST|{reg:HKLM\{#sAppRegPath},{#REG_RABBITMQ_HOST}|{#AmqpServerHost}}}'),
    ExpandConstant('{param:RABBITMQ_USER|{reg:HKLM\{#sAppRegPath},{#REG_RABBITMQ_USER}|{#AmqpServerUserName}}}'),
    ExpandConstant('{param:RABBITMQ_PWD|{reg:HKLM\{#sAppRegPath},{#REG_RABBITMQ_PWD}|{#AmqpServerPassword}}}'),
    ExpandConstant('{param:RABBITMQ_PROTO|{reg:HKLM\{#sAppRegPath},{#REG_RABBITMQ_PROTO}|{#AmqpServerProto}}}'))

  InitDbParams(
    ExpandConstant('{param:DB_HOST|{reg:HKLM\{#sAppRegPath},{#REG_DB_HOST}|{#DbHost}}}'),
    ExpandConstant('{param:DB_PORT|{reg:HKLM\{#sAppRegPath},{#REG_DB_PORT}|{#DbDefPort}}}'),
    ExpandConstant('{param:DB_USER|{reg:HKLM\{#sAppRegPath},{#REG_DB_USER}|{#DbDefUser}}}'),
    ExpandConstant('{param:DB_PWD|{reg:HKLM\{#sAppRegPath},{#REG_DB_PWD}|{code:GetRandomDbPwd}}}'),
    ExpandConstant('{param:DB_NAME|{reg:HKLM\{#sAppRegPath},{#REG_DB_NAME}|{#DbDefName}}}'));

  InitRedisParams(ExpandConstant('{param:REDIS_HOST|{reg:HKLM\{#sAppRegPath},{#REG_REDIS_HOST}|{#RedisHost}}}'));

  InitWopiEnabled(ExpandConstant('{param:WOPI_ENABLED|false}'));
end;

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
  ExtractTemporaryFile('libiconv-2.dll');
  Result := true;
end;

function InitializeSetup(): Boolean;
begin
 
  ExtractFiles();
  Init();
  
  if not UninstallPreviosVersion() then
  begin
    Abort();
  end;
 
  if WizardSilent() = false then
  begin
    Dependency_AddVC2013;
    Dependency_AddVC2015To2022;
  end;

  Result := true;
end;

var
  DbPage: TInputQueryWizardPage;
  RabbitMqPage: TInputQueryWizardPage;
  RedisPage: TInputQueryWizardPage;

function GetDbHost(Param: String): String;
begin
  Result := DbHost;
end;

function GetDbPort(Param: String): String;
begin
  Result := DbPort;
end;

function GetDbUser(Param: String): String;
begin
  Result := DbUserName;
end;

function GetDbPwd(Param: String): String;
begin
  Result := DbPassword;
end;

function GetDbName(Param: String): String;
begin
  Result := DbName;
end;

function GetRabbitMqHost(Param: String): String;
begin
  Result := AmqpServerHost;
end;

function GetRabbitMqUser(Param: String): String;
begin
  Result := AmqpServerUserName;
end;

function GetRabbitMqPwd(Param: String): String;
begin
  Result := AmqpServerPassword;
end;

function GetRabbitMqProto(Param: String): String;
begin
  Result := AmqpServerProto;
end;

function GetRedisHost(Param: String): String;
begin
  Result := RedisHost;
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

function RandomString(StringLen:Integer):String;
var
  str: String;
begin
  str := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLOMNOPQRSTUVWXYZ0123456789';
  Result := '';
  repeat
    Result := Result + str[Random(Length(str)) + 1];
  until(Length(Result) = StringLen)
end;

function SetJWTRandomString(Param: String): String;
begin
  if JWTSecret = '' then
  begin;
    JWTSecret := RandomString(30);
  end;
  Result := JWTSecret;
end;

function IsLocalJsonExists(): Boolean;
begin
  Result := LocalJsonExists;
end;

procedure ssInstallExec;
begin
  if ExpandConstant('{param:JWT_SECRET|{reg:HKLM\{#sAppRegPath},{#REG_JWT_SECRET}}}') <> '' then 
  begin
    IsJWTRegistryExists := True;
  end;
  if FileExists(ExpandConstant('{app}\config\local.json')) then 
  begin
    LocalJsonExists := True;
  end;
end;

procedure ssPostInstallExec;
begin
  if (WizardSilent() = false) and (not IsJWTRegistryExists) and (not IsLocalJsonExists()) and (ExpandConstant('{param:JWT_ENABLED}') <> 'false') then
  begin
    MsgBox(ExpandConstant('{cm:EnableJWT}'), mbInformation, MB_OK);
  end;
end;

function LoadStringFromFile(const FileName: string): string;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

function FormatFileWithNewline(const FileName: string): string;
var
  SL: TStringList;
  i: Integer;
  ResultStr: string;
begin
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);
    ResultStr := '';
    for i := 0 to SL.Count - 1 do
    begin
      ResultStr := ResultStr + SL[i] + '\n';
    end;
    Result := ResultStr;
  finally
    SL.Free;
  end;
end;

function GenerateRSAKey(): Boolean;
var
  ResultCode: Integer;
  Command: String;
  TempFileName: String;
  WopiPrivateKeyPath: String;
  WopiPublicKeyPath: String;
  Output: String;
begin
  Result := False;
  WopiPrivateKeyPath := ExpandConstant('{app}\config\wopi_private_key.pem');
  WopiPublicKeyPath := ExpandConstant('{app}\config\wopi_public_key.pem');
  TempFileName := ExpandConstant('{tmp}\output.txt');

  if not FileExists(WopiPrivateKeyPath) then
  begin
    Command := 'openssl genpkey -algorithm RSA -outform PEM -out "' + WopiPrivateKeyPath + '"';
    Exec('cmd.exe', '/C ' + Command, ExpandConstant('{#OpenSslPath}'), SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end;

  if FileExists(WopiPrivateKeyPath) then
  begin
    Output := FormatFileWithNewline(WopiPrivateKeyPath);
    WopiPrivateKey := Trim(Output);
  end;

  if not FileExists(WopiPublicKeyPath) then
  begin
    Command := 'openssl rsa -RSAPublicKey_out -in "' + WopiPrivateKeyPath + '" -outform "MS PUBLICKEYBLOB" -out "' + WopiPublicKeyPath + '"';
    Exec('cmd.exe', '/C ' + Command, ExpandConstant('{#OpenSslPath}'), SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end;

  if FileExists(WopiPublicKeyPath) then
  begin
    Command := 'openssl base64 -in "' + WopiPublicKeyPath + '" -A > "' + TempFileName + '"';
    Exec('cmd.exe', '/C ' + Command, ExpandConstant('{#OpenSslPath}'), SW_HIDE, ewWaitUntilTerminated, ResultCode);
    if FileExists(TempFileName) then
    begin
      Output := LoadStringFromFile(TempFileName);
      WopiPublicKey := Trim(Output);
      DeleteFile(TempFileName);
    end;
  end;

  if FileExists(WopiPublicKeyPath) then
  begin
    Command := 'openssl rsa -pubin -inform "MS PUBLICKEYBLOB" -modulus -noout -in "' + WopiPublicKeyPath + '" > "' + TempFileName + '"';
    Exec('cmd.exe', '/C ' + Command, ExpandConstant('{#OpenSslPath}'), SW_HIDE, ewWaitUntilTerminated, ResultCode);
    if FileExists(TempFileName) then
    begin
      Output := LoadStringFromFile(TempFileName);
      if Pos('Modulus=', Output) = 1 then
        Delete(Output, 1, 8);
      WopiModulus := Trim(Output);
      DeleteFile(TempFileName);
    end;

    Command := 'openssl rsa -pubin -inform "MS PUBLICKEYBLOB" -text -noout -in "' + WopiPublicKeyPath + '" | findstr "Exponent:" > "' + TempFileName + '"';
    Exec('cmd.exe', '/C ' + Command, ExpandConstant('{#OpenSslPath}'), SW_HIDE, ewWaitUntilTerminated, ResultCode);
    if FileExists(TempFileName) then
    begin
      Output := LoadStringFromFile(TempFileName);
      if Pos('Exponent:', Output) = 1 then
      begin
        Delete(Output, 1, Pos('Exponent:', Output) + 8);
        if Pos('(', Output) > 0 then
          Output := Copy(Output, 1, Pos('(', Output) - 1);
      end;
      WopiExponent := Trim(Output);
      DeleteFile(TempFileName);
    end;
  end;

  Result := True;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then
  begin
    ssInstallExec();
  end;
  if CurStep = ssPostInstall then
  begin
    ssPostInstallExec();
  end;
end;

function GetJwtEnabled(Param: String): String;
begin
  Result := ExpandConstant('{param:JWT_ENABLED|{reg:HKLM\{#sAppRegPath},{#REG_JWT_ENABLED}|true}}');
end;

function GetJwtSecret(Param: String): String;
begin
  Result := ExpandConstant('{param:JWT_SECRET|{reg:HKLM\{#sAppRegPath},{#REG_JWT_SECRET}|{code:SetJWTRandomString}}}');
end;

function GetJwtHeader(Param: String): String;
begin
  Result := ExpandConstant('{param:JWT_HEADER|{reg:HKLM\{#sAppRegPath},{#REG_JWT_HEADER}|Authorization}}');
end;

function GetWopiEnabled(Param: string): String;
begin
  Result := WopiEnabled;
end;

function GetWopiPrivateKey (Param: string): String;
begin
  Result := WopiPrivateKey;
end;

function GetWopiPublicKey(Param: string): String;
begin
  Result := WopiPublicKey;
end;

function GetWopiModulus(Param: string): string;
begin
  Result := WopiModulus;
end;

function GetWopiExponent(Param: string): string;
begin
  Result := WopiExponent;
end;

function IsCommercial: Boolean;
begin
  Result := false;
  if ('{#EDITION}' = 'developer') or ('{#EDITION}' = 'enterprise') then begin
    Result := true;
  end;
end;

function UseLocalStorage: Boolean;
begin
  Result := false;
  if ExpandConstant('{param:UseLocalStorage}') = 'Yes' then
  begin
    Result := True;
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
  DbPage.Add(ExpandConstant('{cm:Port}'), False);
  DbPage.Add(ExpandConstant('{cm:User}'), False);
  DbPage.Add(ExpandConstant('{cm:Password}'), True);
  DbPage.Add(ExpandConstant('{cm:PostgreDb}'), False);

  DbPage.Values[0] := GetDbHost('');
  DbPage.Values[1] := GetDbPort('');
  DbPage.Values[2] := GetDbUser('');
  DbPage.Values[3] := GetDbPwd('');
  DbPage.Values[4] := GetDbName('');

  RabbitMqPage := CreateInputQueryPage(
    DbPage.ID,
    ExpandConstant('{cm:RabbitMq}'),
    FmtMessage(ExpandConstant('{cm:PackageConfigure}'), ['{#RabbitMQ}' + '...']),
    FmtMessage(ExpandConstant('{cm:PackageConnection}'), ['{#RabbitMQ}']));
  RabbitMqPage.Add(ExpandConstant('{cm:Host}'), False);
  RabbitMqPage.Add(ExpandConstant('{cm:User}'), False);
  RabbitMqPage.Add(ExpandConstant('{cm:Password}'), True);
  RabbitMqPage.Add(ExpandConstant('{cm:Protocol}'), False);

  RabbitMqPage.Values[0] := GetRabbitMqHost('');
  RabbitMqPage.Values[1] := GetRabbitMqUser('');
  RabbitMqPage.Values[2] := GetRabbitMqPwd('');
  RabbitMqPage.Values[3] := GetRabbitMqProto('');

  if IsCommercial then
  begin
    RedisPage := CreateInputQueryPage(
      RabbitMqPage.ID,
      ExpandConstant('{cm:Redis}'),
      FmtMessage(ExpandConstant('{cm:PackageConfigure}'), ['{#Redis}' + '...']),
      FmtMessage(ExpandConstant('{cm:PackageConnection}'), ['{#Redis}']));
    RedisPage.Add(ExpandConstant('{cm:Host}'), False);

    RedisPage.Values[0] := GetRedisHost('');
  end;
end;

function GetRandomDbPwd: String;
begin
  Result := RandomString(30);
end;

function SavePgPassConf(Host, Port, DatabaseName, Username, Password: String): Boolean;
var
  FileName: String;
  Content: String;
begin
  FileName := ExpandConstant('{#POSTGRESQL_DATA_DIR}\pgpass.conf');

  Content := Format('%s:%s:%s:%s:%s', [Host, Port, DatabaseName, Username, Password]);

  Result := SaveStringToFile(FileName, Content, False);
end;

function CreateDbDefUserAuth(): Boolean;
begin
  Result := true;

  SavePgPassConf(GetDbHost(''), GetDbPort(''), '{#DbAdminName}', '{#DbAdminUserName}', '{#DbAdminPassword}');
end;

function CreateDbAuth(): Boolean;
begin
  Result := true;

  SavePgPassConf(GetDbHost(''), GetDbPort(''), GetDbName(''), GetDbUser(''), GetDbPwd(''));
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

  if not DirExists(ExpandConstant('{#POSTGRESQL_DATA_DIR}')) then
  begin
    ForceDirectories(ExpandConstant('{#POSTGRESQL_DATA_DIR}'));
  end;

  SaveStringToFile(
    ExpandConstant('{#POSTGRESQL_DATA_DIR}\pgpass.conf'),
    GetDbHost('')+ ':' + GetDbPort('')+ ':' + GetDbName('') + ':' + GetDbUser('') + ':' + GetDbPwd(''),
    False);

  Exec(
    ExpandConstant('{tmp}\psql.exe'),
    '-h ' + GetDbHost('') + ' -U ' + GetDbUser('') + ' -d ' + GetDbName('') + ' -w -c ";"',
    '',
    SW_HIDE,
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
    SW_HIDE,
    EwWaitUntilTerminated,
    ResultCode);

  if ResultCode <> 0 then
  begin
    if MsgBox(
      FmtMessage(ExpandConstant('{cm:NotAvailable}'), ['Python']) +
      FmtMessage(ExpandConstant('{cm:SkipValidation}'), ['{#RabbitMQ}']),
      mbInformation,
      MB_OKCANCEL) = IDOK then
    begin
      Exit;
    end
    else
    begin
      Abort;
    end;
  end;

  if DirExists(ExpandConstant('{sd}') + '\Python\Lib\site-packages\pika') = false then
  begin
    Exec(
    ExpandConstant('{sd}') + '\Python\scripts\pip.exe',
    'install pika',
    '',
    SW_HIDE,
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
      SW_HIDE,
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

    ShellExec(
    '',
    ExpandConstant('{#Python}'),
    '--version',
    '',
    SW_HIDE,
    EwWaitUntilTerminated,
    ResultCode);

  if ResultCode <> 0 then
  begin
    if MsgBox(
      FmtMessage(ExpandConstant('{cm:NotAvailable}'), ['Python']) +
      FmtMessage(ExpandConstant('{cm:SkipValidation}'), ['{#Redis}']),
      mbInformation,
      MB_OKCANCEL) = IDOK then
    begin
      Exit;
    end
    else
    begin
      Abort;
    end;
  end;

  if DirExists(ExpandConstant('{sd}') + '\Python\Lib\site-packages\iredis') = false then
  begin
    Exec(
    ExpandConstant('{sd}') + '\Python\scripts\pip.exe',
    'install iredis',
    '',
    SW_HIDE,
    EwWaitUntilTerminated,
    ResultCode);
  end;

  Exec(
  ExpandConstant('{sd}') + '\Python\scripts\iredis.exe',
  '-h ' + GetRedisHost('') + ' quit',
  '',
  SW_HIDE,
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
      Result := WizardIsComponentSelected('Prerequisites\PostgreSQL');
    RabbitMqPage.ID:
      Result := WizardIsComponentSelected('Prerequisites\RabbitMq');
  else
    if IsCommercial then
    begin
      if PageID = RedisPage.ID then
      begin
        Result := WizardIsComponentSelected('Prerequisites\Redis') or UseLocalStorage;
      end;
    end;
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
        '/C netstat -aon | findstr :' + IntToStr(Ports[I]) + ' "',
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
      begin
        InitDbParams(DbPage.Values[0], DbPage.Values[1], DbPage.Values[2], DbPage.Values[3], DbPage.Values[4]);
        Result := CheckDbConnection();
      end;
      RabbitMqPage.ID:
      begin
        InitAmqpServerParams(RabbitMqPage.Values[0], RabbitMqPage.Values[1], RabbitMqPage.Values[2], RabbitMqPage.Values[3]);
        Result := CheckRabbitMqConnection();
      end;
      wpWelcome:
        Result := CheckPortOccupied();
      wpSelectComponents:
      begin
           if WizardIsComponentSelected('Prerequisites\Redis') then
           begin
             Dependency_AddRedis;
           end;
           if WizardIsComponentSelected('Prerequisites\RabbitMq') then
           begin
             Dependency_AddErlang;
             Dependency_AddRabbitMq;
           end;
           if WizardIsComponentSelected('Prerequisites\PostgreSQL') then
           begin
             Dependency_AddPostgreSQL;
           end;
        if WizardIsComponentSelected('Prerequisites\Certbot') then
        begin
          Dependency_AddCertbot;
        end;
        if WizardIsComponentSelected('Prerequisites\Python') then
        begin
          Dependency_AddPython3;
        end;
        if WizardIsComponentSelected('Prerequisites\OpenSSL') then
        begin
          Dependency_AddOpenSSL;
        end;
       end;
       else
         if IsCommercial then
          begin
            if CurPageID = RedisPage.ID then
            begin
              InitRedisParams(RedisPage.Values[0]);
              Result := CheckRedisConnection();
            end;
         end;
    end;
  end;
end;

#ifdef DS_EXAMPLE
#include "example.iss"
#endif
