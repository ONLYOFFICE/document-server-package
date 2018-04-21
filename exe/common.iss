#ifndef sPackageName
  #define sPackageName        'onlyoffice-documentserver'
#endif

#define sAppName            'ONLYOFFICE DocumentServer'
#define APP_PATH            'ONLYOFFICE\DocumentServer'
#define APP_REG_PATH        'Software\ONLYOFFICE\DocumentServer'

#define REG_LICENSE_PATH      'LicensePath'
#define REG_DB_HOST           'DbHost'
#define REG_DB_USER           'DbUser'
#define REG_DB_PWD            'DbPwd'
#define REG_DB_NAME           'DbName'
#define REG_RABBITMQ_HOST     'RabbitMqHost'
#define REG_RABBITMQ_USER     'RabbitMqUser'
#define REG_RABBITMQ_PWD      'RabbitMqPwd'
#define REG_REDIS_HOST        'RedisHost'
#define REG_DS_PORT           'DsPort'
#define REG_EXAMPLE_PORT      'ExamplePort'
#define REG_DOCSERVICE_PORT   'DocServicePort'
#define REG_SPELLCHECKER_PORT 'SpellCheckerPort'
#define REG_FONTS_PATH        'FontsPath'
#define REG_JWT_ENABLED       'JwtEnabled'
#define REG_JWT_SECRET        'JwtSecret'
#define REG_JWT_HEADER        'JwtHeader'

#define iconsExe            'projicons.exe'

#ifndef sAppVersion
  #define sAppVersion         '4.0.0.0'
#endif

#define sAppVerShort

#define NSSM                  '{app}\nssm\nssm.exe'
#define NODE_SRV_ENV          'NODE_ENV=production-windows NODE_CONFIG_DIR=""{app}\config"" NODE_DISABLE_COLORS=1'

#define LOCAL_SERVICE 'Local Service'

#define CONVERTER_SRV        'DsConverterSvc'
#define CONVERTER_SRV_DISPLAY  'ONLYOFFICE DocumentServer Converter'
#define CONVERTER_SRV_DESCR  'ONLYOFFICE DocumentServer Converter Service'
#define CONVERTER_SRV_DIR    '{app}\server\FileConverter\sources'
#define CONVERTER_SRV_LOG_DIR    '{app}\Log\converter'

#define DOCSERVICE_SRV        'DsDocServiceSvc'
#define DOCSERVICE_SRV_DISPLAY  'ONLYOFFICE DocumentServer DocService'
#define DOCSERVICE_SRV_DESCR  'ONLYOFFICE DocumentServer DocService Service'
#define DOCSERVICE_SRV_DIR    '{app}\server\docservice\sources'
#define DOCSERVICE_SRV_LOG_DIR    '{app}\Log\docservice'

#define GC_SRV        'DsGcSvc'
#define GC_SRV_DISPLAY  'ONLYOFFICE DocumentServer Gc'
#define GC_SRV_DESCR  'ONLYOFFICE DocumentServer Gc Service'
#define GC_SRV_DIR    '{app}\server\docservice\sources'
#define GC_SRV_LOG_DIR    '{app}\Log\gc'

#define SPELLCHECKER_SRV        'DsSpellcheckerSvc'
#define SPELLCHECKER_SRV_DISPLAY  'ONLYOFFICE DocumentServer Spellchecker'
#define SPELLCHECKER_SRV_DESCR  'ONLYOFFICE DocumentServer Spellchecker Service'
#define SPELLCHECKER_SRV_DIR    '{app}\server\SpellChecker\sources'
#define SPELLCHECKER_SRV_LOG_DIR    '{app}\Log\spellchecker'

#define PSQL '{app}\pgsql\bin\psql.exe'
#define POSTGRESQL_DATA_DIR '{userappdata}\postgresql'
#define REDISCLI '{pf64}\Redis\redis-cli.exe'
#define RABBITMQCTL '{pf64}\RabbitMQ Server\rabbitmq_server-3.6.5\sbin\rabbitmqctl.bat'

#define NODE_PATH '{pf64}\nodejs'
#define NPM '{pf64}\nodejs\npm'
#define JSON '{userappdata}\npm\json.cmd'

#define JSON_PARAMS '-I -q -f ""{app}\config\local.json""'

#define REPLACE '{userappdata}\npm\replace.cmd'

#define NGINX_SRV  'DsProxySvc'
#define NGINX_SRV_DISPLAY  'ONLYOFFICE DocumentServer Proxy'
#define NGINX_SRV_DESCR  'ONLYOFFICE DocumentServer Proxy Service'
#define NGINX_SRV_DIR  '{app}\nginx'
#define NGINX_SRV_LOG_DIR    '{app}\Log\nginx'
#define NGINX_DS_CONF '{app}\nginx\conf\onlyoffice-documentserver.conf'
#define NGINX_DS_TMPL '{app}\nginx\conf\onlyoffice-documentserver.conf.template'
#define NGINX_DS_SSL_TMPL '{app}\nginx\conf\onlyoffice-documentserver-ssl.conf.template'

#define LICENSE_PATH '{commonappdata}\ONLYOFFICE\Data'

[Setup]
AppName                   ={#sAppName}
AppVerName                ={#sAppName} {#sAppVerShort}
AppVersion                ={#sAppVersion}
VersionInfoVersion        ={#sAppVersion}
OutputBaseFilename        ={#sPackageName}-{#sAppVersion}

AppPublisher            =Ascensio System SIA.
AppPublisherURL         =http://www.onlyoffice.com/
AppSupportURL           =http://www.onlyoffice.com/support.aspx
AppCopyright            =Copyright (C) 2018 Ascensio System SIA.

ArchitecturesAllowed              =x64
ArchitecturesInstallIn64BitMode   =x64

DefaultGroupName        =ONLYOFFICE
;WizardImageFile         = data\dialogpicture.bmp
;WizardSmallImageFile    = data\dialogicon.bmp


UsePreviousAppDir         = yes
DirExistsWarning          =no
DefaultDirName            ={pf}\{#APP_PATH}
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
WizardImageFile           = data\dialogpicture.bmp
WizardSmallImageFile      = data\dialogicon.bmp
SetupIconFile             = data\icon.ico
LicenseFile               = ..\common\documentserver\license\{#sPackageName}\LICENSE.txt

#ifdef ISPPCC_INVOKED
SignTool=byparam $p
#endif

[CustomMessages]
GenFonts=Generating AllFonts.js...
InstallSrv=Installing service %1...
CfgSrv=Configuring service %1...
StartSrv=Starting service %1...
InstallNpm=Installing npm modules...
CreateDb=Creating database...
RemoveDb=Removing database...
FireWallExt=Adding firewall extention..

CfgDs=Configuring {#sAppName}...
Uninstall=Uninstall {#sAppName}
PrevVer=The previous version of {#sAppName} detected, please click 'OK' button to uninstall it, or 'Cancel' to quit setup.

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
;Name: "de"; MessagesFile: "compiler:Languages\German.isl"
;Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
;Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
;Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
;Name: "pl"; MessagesFile: "compiler:Languages\Polish.isl"

[Files]
Source: ..\common\documentserver\home\*;            DestDir: {app}; Flags: ignoreversion recursesubdirs;
Source: ..\common\documentserver\config\*;          DestDir: {app}\config; Flags: ignoreversion recursesubdirs; Permissions: users-readexec
Source: local\local.json;                           DestDir: {app}\config; Flags: onlyifdoesntexist uninsneveruninstall
Source: ..\common\documentserver\bin\*.bat;         DestDir: {app}\bin; Flags: ignoreversion recursesubdirs
Source: nginx\nginx.conf;                           DestDir: {#NGINX_SRV_DIR}\conf; Flags: ignoreversion recursesubdirs
Source: ..\common\documentserver\nginx\*;           DestDir: {#NGINX_SRV_DIR}\conf; Flags: ignoreversion recursesubdirs
Source: ..\common\documentserver\nginx\onlyoffice-documentserver.conf.template; DestDir: {#NGINX_SRV_DIR}\conf; DestName: onlyoffice-documentserver.conf; Flags: onlyifdoesntexist uninsneveruninstall

[Dirs]
Name: "{app}\server\App_Data";        Permissions: users-modify
Name: "{app}\server\App_Data\cache\files"; Permissions: users-modify
Name: "{app}\server\App_Data\docbuilder"; Permissions: users-modify
Name: "{app}\sdkjs";                  Permissions: users-modify
Name: "{app}\fonts";                  Permissions: users-modify
Name: "{#CONVERTER_SRV_LOG_DIR}";     Permissions: users-modify
Name: "{#DOCSERVICE_SRV_LOG_DIR}";    Permissions: users-modify
Name: "{#GC_SRV_LOG_DIR}";            Permissions: users-modify
Name: "{#SPELLCHECKER_SRV_LOG_DIR}";  Permissions: users-modify
Name: "{#NGINX_SRV_DIR}";             Permissions: users-modify
Name: "{#NGINX_SRV_LOG_DIR}";         Permissions: users-modify
Name: "{#NGINX_SRV_DIR}\temp";        Permissions: users-modify
Name: "{#NGINX_SRV_DIR}\logs";        Permissions: users-modify
Name: "{#POSTGRESQL_DATA_DIR}";
Name: "{#LICENSE_PATH}";

[Icons]
Name: "{group}\{cm:Uninstall}"; Filename: "{uninstallexe}"

[Registry]
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_DB_HOST}"; ValueData: "{code:GetDbHost}";
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_DB_USER}"; ValueData: "{code:GetDbUser}";
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_DB_PWD}"; ValueData: "{code:GetDbPwd}";
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_DB_NAME}"; ValueData: "{code:GetDbName}";
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_RABBITMQ_HOST}"; ValueData: "{code:GetRabbitMqHost}";
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_RABBITMQ_USER}"; ValueData: "{code:GetRabbitMqUser}";
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_RABBITMQ_PWD}"; ValueData: "{code:GetRabbitMqPwd}";
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_REDIS_HOST}"; ValueData: "{code:GetRedisHost}";
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_LICENSE_PATH}"; ValueData: "{code:GetLicensePath}"; Check: not IsStringEmpty(ExpandConstant('{param:LICENSE_PATH}'));
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_DS_PORT}"; ValueData: "{code:GetDefaultPort}"; Check: not IsStringEmpty(ExpandConstant('{param:DS_PORT}'));
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_DOCSERVICE_PORT}"; ValueData: "{code:GetDocServicePort}"; Check: not IsStringEmpty(ExpandConstant('{param:DOCSERVICE_PORT}'));
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_SPELLCHECKER_PORT}"; ValueData: "{code:GetSpellCheckerPort}"; Check: not IsStringEmpty(ExpandConstant('{param:SPELLCHECKER_PORT}'));
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_FONTS_PATH}"; ValueData: "{code:GetFontsPath}"; Check: not IsStringEmpty(ExpandConstant('{param:FONTS_PATH}'));
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_JWT_ENABLED}"; ValueData: "{code:GetJwtEnabled}"; Check: not IsStringEmpty(ExpandConstant('{param:JWT_ENABLED}'));
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_JWT_SECRET}"; ValueData: "{code:GetJwtSecret}";  Check: not IsStringEmpty(ExpandConstant('{param:JWT_SECRET}'));
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_JWT_HEADER}"; ValueData: "{code:GetJwtHeader}"; Check: not IsStringEmpty(ExpandConstant('{param:JWT_HEADER}'));

[Run]
Filename: "{app}\bin\documentserver-generate-allfonts.bat"; Parameters: "true"; Flags: runhidden; StatusMsg: "{cm:GenFonts}"

Filename: "{#NPM}"; Parameters: "install -g json"; Flags: runhidden shellexec waituntilterminated; StatusMsg: "{cm:InstallNpm}"
Filename: "{#NPM}"; Parameters: "install -g replace"; Flags: runhidden shellexec waituntilterminated; StatusMsg: "{cm:InstallNpm}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services===undefined)this.services={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring===undefined)this.services.CoAuthoring={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.sql===undefined)this.services.CoAuthoring.sql={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbHost = '{code:GetDbHost}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbUser = '{code:GetDbUser}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbPass = '{code:GetDbPwd}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbName = '{code:GetDbName}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.rabbitmq===undefined)this.rabbitmq={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.rabbitmq.url = 'amqp://{code:GetRabbitMqUser}:{code:GetRabbitMqPwd}@{code:GetRabbitMqHost}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.redis===undefined)this.services.CoAuthoring.redis={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.redis.host = '{code:GetRedisHost}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.server===undefined)this.services.CoAuthoring.server={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.server.port = '{code:GetDocServicePort}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.SpellChecker===undefined)this.services.SpellChecker={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.SpellChecker.server===undefined)this.services.SpellChecker.server={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.SpellChecker.server.port = '{code:GetSpellCheckerPort}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.license===undefined)this.license={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.license.license_file = '{code:GetLicensePath}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.utils===undefined)this.services.CoAuthoring.utils={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.utils.utils_common_fontdir = '{code:GetFontsPath}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.token===undefined)this.services.CoAuthoring.token={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.token.enable===undefined)this.services.CoAuthoring.token.enable={{request:{{}}"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.enable.browser = {code:GetJwtEnabled}"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.enable.request.inbox = {code:GetJwtEnabled}"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.enable.request.outbox = {code:GetJwtEnabled}"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.secret===undefined)this.services.CoAuthoring.secret={{inbox:{{},outbox:{{},session: {{} };"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.secret.inbox.string = '{code:GetJwtSecret}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.secret.outbox.string = '{code:GetJwtSecret}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.secret.session.string = '{code:GetJwtSecret}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.token.inbox===undefined)this.services.CoAuthoring.token.inbox={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.inbox.header = '{code:GetJwtHeader}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""if(this.services.CoAuthoring.token.outbox===undefined)this.services.CoAuthoring.token.outbox={{};"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.token.outbox.header = '{code:GetJwtHeader}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#REPLACE}"; Parameters: """(listen .*:)(\d{{2,5}\b)(?! ssl)(.*)"" ""$1""{code:GetDefaultPort}""$3"" ""{#NGINX_DS_CONF}"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
; Filename: "{cmd}"; Parameters: "/C COPY /Y ""{#NGINX_DS_TMPL}"" ""{#NGINX_DS_CONF}"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
; Filename: "{#REPLACE}"; Parameters: "{{{{DOCSERVICE_PORT}} {code:GetDocServicePort} ""{#NGINX_SRV_DIR}\conf\includes\onlyoffice-http.conf"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
; Filename: "{#REPLACE}"; Parameters: "{{{{SPELLCHECKER_PORT}} {code:GetSpellCheckerPort} ""{#NGINX_SRV_DIR}\conf\includes\onlyoffice-http.conf"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"
; Filename: "{#REPLACE}"; Parameters: "{{{{EXAMPLE_PORT}} {code:GetExamplePort} ""{#NGINX_SRV_DIR}\conf\includes\onlyoffice-http.conf"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:CfgDs}"

Filename: "{#PSQL}"; Parameters: "-h {code:GetDbHost} -U {code:GetDbUser} -d {code:GetDbName} -w -q -f ""{app}\server\schema\postgresql\removetbl.sql"""; Flags: runhidden; Check: IsNotClusterMode; StatusMsg: "{cm:RemoveDb}"
Filename: "{#PSQL}"; Parameters: "-h {code:GetDbHost} -U {code:GetDbUser} -d {code:GetDbName} -w -q -f ""{app}\server\schema\postgresql\createdb.sql"""; Flags: runhidden; Check: CreateDbAuth; StatusMsg: "{cm:CreateDb}"

Filename: "{#NSSM}"; Parameters: "install {#CONVERTER_SRV} node --max_old_space_size=4096 convertermaster.js"; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} DisplayName {#CONVERTER_SRV_DISPLAY}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} Description {#CONVERTER_SRV_DESCR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppDirectory {#CONVERTER_SRV_DIR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppStdout {#CONVERTER_SRV_LOG_DIR}\out.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppStderr {#CONVERTER_SRV_LOG_DIR}\error.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} ObjectName ""{#LOCAL_SERVICE}"" """" "; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#CONVERTER_SRV}}"
Filename: "{#NSSM}"; Parameters: "start {#CONVERTER_SRV}"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#CONVERTER_SRV}}"

Filename: "{#NSSM}"; Parameters: "install {#DOCSERVICE_SRV} node --max_old_space_size=4096 server.js"; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} DisplayName {#DOCSERVICE_SRV_DISPLAY}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} Description {#DOCSERVICE_SRV_DESCR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppDirectory {#DOCSERVICE_SRV_DIR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppStdout {#DOCSERVICE_SRV_LOG_DIR}\out.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppStderr {#DOCSERVICE_SRV_LOG_DIR}\error.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} ObjectName ""{#LOCAL_SERVICE}"" """" "; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#DOCSERVICE_SRV}}"
Filename: "{#NSSM}"; Parameters: "start {#DOCSERVICE_SRV}"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#DOCSERVICE_SRV}}"

Filename: "{#NSSM}"; Parameters: "install {#GC_SRV} node gc.js"; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#GC_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} DisplayName {#GC_SRV_DISPLAY}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#GC_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} Description {#GC_SRV_DESCR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#GC_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppDirectory {#GC_SRV_DIR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#GC_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#GC_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppStdout {#GC_SRV_LOG_DIR}\out.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#GC_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppStderr {#GC_SRV_LOG_DIR}\error.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#GC_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} ObjectName ""{#LOCAL_SERVICE}"" """" "; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#GC_SRV}}"
Filename: "{#NSSM}"; Parameters: "start {#GC_SRV}"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#GC_SRV}}"

Filename: "{#NSSM}"; Parameters: "install {#SPELLCHECKER_SRV} node server.js"; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#SPELLCHECKER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} DisplayName {#SPELLCHECKER_SRV_DISPLAY}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#SPELLCHECKER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} Description {#SPELLCHECKER_SRV_DESCR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#SPELLCHECKER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppDirectory {#SPELLCHECKER_SRV_DIR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#SPELLCHECKER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#SPELLCHECKER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppStdout {#SPELLCHECKER_SRV_LOG_DIR}\out.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#SPELLCHECKER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppStderr {#SPELLCHECKER_SRV_LOG_DIR}\error.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#SPELLCHECKER_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} ObjectName ""{#LOCAL_SERVICE}"" """" "; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#SPELLCHECKER_SRV}}"
Filename: "{#NSSM}"; Parameters: "start {#SPELLCHECKER_SRV}"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#SPELLCHECKER_SRV}}"

Filename: "{#NSSM}"; Parameters: "install {#NGINX_SRV} ""{#NGINX_SRV_DIR}\nginx"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} DisplayName {#NGINX_SRV_DISPLAY}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} Description {#NGINX_SRV_DESCR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} AppDirectory {#NGINX_SRV_DIR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} AppStdout {#NGINX_SRV_LOG_DIR}\out.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} AppStderr {#NGINX_SRV_LOG_DIR}\error.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#NGINX_SRV} ObjectName ""{#LOCAL_SERVICE}"" """" "; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#NGINX_SRV}}"
Filename: "{#NSSM}"; Parameters: "start {#NGINX_SRV}"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#NGINX_SRV}}"

Filename: "{sys}\netsh.exe"; Parameters: "firewall add allowedprogram ""{#NGINX_SRV_DIR}\nginx.exe"" ""{#NGINX_SRV_DESCR}"" ENABLE ALL"; Flags: runhidden; StatusMsg: "{cm:FireWallExt}"

[UninstallRun]
Filename: "{app}\bin\documentserver-prepare4shutdown.bat"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#NGINX_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#NGINX_SRV} confirm"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#CONVERTER_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#CONVERTER_SRV} confirm"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#DOCSERVICE_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#DOCSERVICE_SRV} confirm"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#GC_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#GC_SRV} confirm"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#SPELLCHECKER_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#SPELLCHECKER_SRV} confirm"; Flags: runhidden

Filename: {sys}\netsh.exe; Parameters: "firewall delete allowedprogram program=""{#NGINX_SRV_DIR}\nginx.exe"""; Flags: runhidden

[UninstallDelete]
Type: filesandordirs; Name: "{app}\sdkjs"
Type: filesandordirs; Name: "{app}\fonts"
Type: files; Name: "{app}\server\FileConverter\bin\font_selection.bin"
Type: files; Name: "{app}\server\FileConverter\bin\AllFonts.js"

; shared code for installing the products
#include "scripts\products.iss"
; helper functions
#include "scripts\products\stringversion.iss"
#include "scripts\products\winversion.iss"
#include "scripts\products\fileversion.iss"

#include "scripts\products\msiproduct.iss"
#include "scripts\products\vcredist2010sp1.iss"
#include "scripts\products\vcredist2013.iss"
#include "scripts\products\vcredist2015.iss"
#include "scripts\products\nodejs6x.iss"
#include "scripts\products\postgresql.iss"
#include "scripts\products\rabbitmq.iss"
#include "scripts\products\redis.iss"

#include "scripts\service.iss"

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
  UninstallRegKey := '{reg:HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#sAppName}_is1,UninstallString}';

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

function InitializeSetup(): Boolean;
begin
  // initialize windows version
  initwinversion();
  
  if not UninstallPreviosVersion() then
  begin
    Abort();
  end;
 
  vcredist2010();
  vcredist2013();
  vcredist2015();
  nodejs6x('6.9.1.0');
  //postgresql('9.5.4.0');
  //rabbitmq('3.6.5');
  //redis('3.2.100');

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

function GetRedisHost(Param: String): String;
begin
  Result := RedisPage.Values[0];
end;

function GetDefaultPort(Param: String): String;
begin
  Result := ExpandConstant('{param:DS_PORT|{reg:HKLM\{#APP_REG_PATH},{#REG_DS_PORT}|80}}');
end;

function GetDocServicePort(Param: String): String;
begin
  Result := ExpandConstant('{param:DOCSERVICE_PORT|{reg:HKLM\{#APP_REG_PATH},{#REG_DOCSERVICE_PORT}|8000}}');
end;

function GetSpellCheckerPort(Param: String): String;
begin
  Result := ExpandConstant('{param:SPELLCHECKER_PORT|{reg:HKLM\{#APP_REG_PATH},{#REG_SPELLCHECKER_PORT}|8080}}');
end;

function GetExamplePort(Param: String): String;
begin
  Result := ExpandConstant('{param:EXAMPLE_PORT|{reg:HKLM\{#APP_REG_PATH},{#REG_EXAMPLE_PORT}|3000}}');
end;

function GetLicensePath(Param: String): String;
var
  LicensePath: String;
begin
  LicensePath := ExpandConstant('{param:LICENSE_PATH|{reg:HKLM\{#APP_REG_PATH},{#REG_LICENSE_PATH}|{#LICENSE_PATH}\license.lic}}');
  StringChangeEx(LicensePath, '\', '/', True);
  Result := LicensePath;
end;

function GetFontsPath(Param: String): String;
var
  FontPath: String;
begin
  FontPath := ExpandConstant('{param:FONTS_PATH|{reg:HKLM\{#APP_REG_PATH},{#REG_FONTS_PATH}|{fonts}}}');
  StringChangeEx(FontPath, '\', '/', True);
  Result := FontPath;
end;

function GetJwtEnabled(Param: String): String;
begin
  Result := ExpandConstant('{param:JWT_ENABLED|{reg:HKLM\{#APP_REG_PATH},{#REG_JWT_ENABLED}|false}}');
end;

function GetJwtSecret(Param: String): String;
begin
  Result := ExpandConstant('{param:JWT_SECRET|{reg:HKLM\{#APP_REG_PATH},{#REG_JWT_SECRET}|secret}}');
end;

function GetJwtHeader(Param: String): String;
begin
  Result := ExpandConstant('{param:JWT_HEADER|{reg:HKLM\{#APP_REG_PATH},{#REG_JWT_HEADER}|Authorization}}');
end;

procedure InitializeWizard;
begin
  DbPage := CreateInputQueryPage(wpPreparing,
    'PostgreSQL Database', 'Configure PostgreSQL Connection...',
    'Please specify your PostgreSQL connection, then click Next.');
  DbPage.Add('Host:', False);
  DbPage.Add('User:', False);
  DbPage.Add('Password:', True);
  DbPage.Add('Database:', False);

  DbPage.Values[0] := ExpandConstant('{param:DB_HOST|{reg:HKLM\{#APP_REG_PATH},{#REG_DB_HOST}|localhost}}');
  DbPage.Values[1] := ExpandConstant('{param:DB_USER|{reg:HKLM\{#APP_REG_PATH},{#REG_DB_USER}|onlyoffice}}');
  DbPage.Values[2] := ExpandConstant('{param:DB_PWD|{reg:HKLM\{#APP_REG_PATH},{#REG_DB_PWD}|onlyoffice}}');
  DbPage.Values[3] := ExpandConstant('{param:DB_NAME|{reg:HKLM\{#APP_REG_PATH},{#REG_DB_NAME}|onlyoffice}}');

  RabbitMqPage := CreateInputQueryPage(DbPage.ID,
    'RabbitMQ Messaging Broker', 'Configure RabbitMQ Connection...',
    'Please specify your RabbitMQ connection, then click Next.');
  RabbitMqPage.Add('Host:', False);
  RabbitMqPage.Add('User:', False);
  RabbitMqPage.Add('Password:', True);

  RabbitMqPage.Values[0] := ExpandConstant('{param:RABBITMQ_HOST|{reg:HKLM\{#APP_REG_PATH},{#REG_RABBITMQ_HOST}|localhost}}');
  RabbitMqPage.Values[1] := ExpandConstant('{param:RABBITMQ_USER|{reg:HKLM\{#APP_REG_PATH},{#REG_RABBITMQ_USER}|guest}}');
  RabbitMqPage.Values[2] := ExpandConstant('{param:RABBITMQ_PWD|{reg:HKLM\{#APP_REG_PATH},{#REG_RABBITMQ_PWD}|guest}}');

  RedisPage := CreateInputQueryPage(RabbitMqPage.ID,
    'Redis In-Memory Database', 'Configure Redis Connection...',
    'Please specify your Reids connection, then click Next.');
  RedisPage.Add('Host:', False);

  RedisPage.Values[0] := ExpandConstant('{param:REDIS_HOST|{reg:HKLM\{#APP_REG_PATH},{#REG_REDIS_HOST}|localhost}}');

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
    ExpandConstant('{#PSQL}'),
    '-h ' + GetDbHost('') + ' -U ' + GetDbUser('') + ' -d ' + GetDbName('') + ' -w -c ";"',
    '', 
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode);

  if ResultCode <> 0 then
  begin
    MsgBox('Connection to ' + GetDbHost('') + ' failed!' + #13#10 + 'PSQL return ' + IntToStr(ResultCode)+ ' code.' +  #13#10 + 'Check the connection settings and try again.', mbError, MB_OK);
    Result := false;
  end;
end;

function CheckRabbitMqConnection(): Boolean;
var
  ResultCode: Integer;
begin
  Result := true;
    Exec(
    ExpandConstant('{#RABBITMQCTL}'),
    '-q list_queues',
    '', 
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode);

  if ResultCode <> 0 then
  begin
    MsgBox('Connection to ' + GetRedisHost('') + ' failed!' + #13#10 + 'rabbitmqctl return ' + IntToStr(ResultCode)+ ' code.' +  #13#10 + 'Check the connection settings and try again.', mbError, MB_OK);
    Result := false;
  end;
end;

function CheckRedisConnection(): Boolean;
var
  ResultCode: Integer;
begin
  Result := true;
    Exec(
    ExpandConstant('{#REDISCLI}'),
    '-h ' + GetRedisHost('') + ' --version',
    '', 
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode);

  if ResultCode <> 0 then
  begin
    MsgBox('Connection to ' + GetRedisHost('') + ' failed!' + #13#10 + 'redis-cli return ' + IntToStr(ResultCode)+ ' code.' +  #13#10 + 'Check the connection settings and try again.', mbError, MB_OK);
    Result := false;
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := true;
  if WizardSilent() = false then
  begin
    case CurPageID of
//      DbPage.ID: Result := CheckDbConnection();
//      RabbitMqPage.ID: Result := CheckRabbitMqConnection();
//      RedisPage.ID: Result := CheckRedisConnection();
      wpReady: Result := DownloadDependency();
    end;
  end;
end;                                                     

