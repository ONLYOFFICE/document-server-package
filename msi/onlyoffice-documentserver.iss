#define sAppName            'ONLYOFFICE Document Server'
#define APP_PATH            'ONLYOFFICE\DocumentServer'
#define APP_REG_PATH        'Software\ONLYOFFICE\DocumentServer'
#define NAME_EXE_OUT        'DocumentServer.exe'
#define iconsExe            'projicons.exe'

#define sAppVersion         '4.0.4'
#define sAppVerShort

#define NSSM                  '{app}\server\Winser\node_modules\winser\bin\nssm64.exe'
#define NODE_SRV_ENV          'NODE_ENV=production-windows NODE_CONFIG_DIR=""{app}\server\Common\config"" NODE_DISABLE_COLORS=1'

#define CONVERTER_SRV        'ds_converter'
#define CONVERTER_SRV_DESCR  'converter description'
#define CONVERTER_SRV_DIR    '{app}\server\FileConverter\sources'
#define CONVERTER_SRV_LOG_DIR    '{app}\Log\converter'

#define DOCSERVICE_SRV        'ds_docservice'
#define DOCSERVICE_SRV_DESCR  'docservice description'
#define DOCSERVICE_SRV_DIR    '{app}\server\docservice\sources'
#define DOCSERVICE_SRV_LOG_DIR    '{app}\Log\docservice'

#define GC_SRV        'ds_gc'
#define GC_SRV_DESCR  'gc description'
#define GC_SRV_DIR    '{app}\server\docservice\sources'
#define GC_SRV_LOG_DIR    '{app}\Log\gc'

#define SPELLCHECKER_SRV        'ds_spellchecker'
#define SPELLCHECKER_SRV_DESCR  'spelchecker description'
#define SPELLCHECKER_SRV_DIR    '{app}\server\SpellChecker\sources'
#define SPELLCHECKER_SRV_LOG_DIR    '{app}\Log\spellchecker'

#define PSQL '{pf64}\PostgreSQL\9.5\bin\psql.exe'

[Setup]
AppName                   ={#sAppName}
AppVerName                ={#sAppName} {#sAppVerShort}
AppVersion                ={#sAppVersion}
VersionInfoVersion        ={#sAppVersion}

AppPublisher            =Ascensio System SIA.
AppPublisherURL         =http://www.onlyoffice.com/
AppSupportURL           =http://www.onlyoffice.com/support.aspx
AppCopyright            =Copyright (C) 2016 Ascensio System SIA.

ArchitecturesAllowed              =x64
ArchitecturesInstallIn64BitMode   =x64

DefaultGroupName        =ONLYOFFICE
;WizardImageFile         = data\dialogpicture.bmp
;WizardSmallImageFile    = data\dialogicon.bmp


UsePreviousAppDir         =no
DirExistsWarning          =no
DefaultDirName            ={pf}\{#APP_PATH}
DisableProgramGroupPage   = yes
DisableWelcomePage        = no
DEPCompatible             = no
ASLRCompatible            = no
DisableDirPage            = auto
AllowNoIcons              = yes
AlwaysShowDirOnReadyPage  = yes
UninstallDisplayIcon      = {app}\{#NAME_EXE_OUT}
OutputDir                 =.\
Compression               =none
PrivilegesRequired        =admin
ChangesEnvironment        =yes
SetupMutex                =ASC

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "pl"; MessagesFile: "compiler:Languages\Polish.isl"

[Dirs]
Name: {commonappdata}\{#APP_PATH}\webdata\cloud; Flags: uninsalwaysuninstall

[Files]
Source: ..\common\documentserver\home\*;           DestDir: {app}; Flags: ignoreversion recursesubdirs
Source: ..\common\documentserver\bin\*.bat;           DestDir: {app}\bin; Flags: ignoreversion recursesubdirs

[Dirs]
Name: "{app}\App_Data";               Permissions: users-full
Name: "{#CONVERTER_SRV_LOG_DIR}";     Permissions: users-full
Name: "{#DOCSERVICE_SRV_LOG_DIR}";    Permissions: users-full
Name: "{#GC_SRV_LOG_DIR}";            Permissions: users-full
Name: "{#SPELLCHECKER_SRV_LOG_DIR}";  Permissions: users-full

[Run]
Filename: "{app}\bin\documentserver-generate-allfonts.bat"; Flags: runhidden

Filename: "{#PSQL}"; Parameters: "-h localhost -U onlyoffice -d onlyoffice -f ""{app}\server\schema\postgresql\createdb.sql""";

Filename: "{#NSSM}"; Parameters: "install {#CONVERTER_SRV} node convertermaster.js"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} Description {#CONVERTER_SRV_DESCR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppDirectory {#CONVERTER_SRV_DIR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppStdout {#CONVERTER_SRV_LOG_DIR}\out.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppStderr {#CONVERTER_SRV_LOG_DIR}\error.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "start {#CONVERTER_SRV}"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "install {#DOCSERVICE_SRV} node server.js"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} Description {#DOCSERVICE_SRV_DESCR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppDirectory {#DOCSERVICE_SRV_DIR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppStdout {#DOCSERVICE_SRV_LOG_DIR}\out.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppStderr {#DOCSERVICE_SRV_LOG_DIR}\error.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "start {#DOCSERVICE_SRV}"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "install {#GC_SRV} node gc.js"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} Description {#GC_SRV_DESCR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppDirectory {#GC_SRV_DIR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppStdout {#GC_SRV_LOG_DIR}\out.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppStderr {#GC_SRV_LOG_DIR}\error.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "start {#GC_SRV}"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "install {#SPELLCHECKER_SRV} node server.js"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} Description {#SPELLCHECKER_SRV_DESCR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppDirectory {#SPELLCHECKER_SRV_DIR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppStdout {#SPELLCHECKER_SRV_LOG_DIR}\out.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppStderr {#SPELLCHECKER_SRV_LOG_DIR}\error.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "start {#SPELLCHECKER_SRV}"; Flags: runhidden

[UninstallRun]
Filename: "{#NSSM}"; Parameters: "stop {#CONVERTER_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#CONVERTER_SRV} confirm"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#DOCSERVICE_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#DOCSERVICE_SRV} confirm"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#GC_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#GC_SRV} confirm"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#SPELLCHECKER_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#SPELLCHECKER_SRV} confirm"; Flags: runhidden

[UninstallDelete]
Type: filesandordirs; Name: "{app}\*"

; shared code for installing the products
#include "scripts\products.iss"
; helper functions
#include "scripts\products\stringversion.iss"
#include "scripts\products\winversion.iss"
#include "scripts\products\fileversion.iss"

#include "scripts\products\nodejs4x.iss"

[Code]
function InitializeSetup(): boolean;
begin
	// initialize windows version
	initwinversion();

  nodejs4x('4.0.0');

	Result := true;
end;
