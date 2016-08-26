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

#define DOCSERVICE_SRV        'ds_docservice'
#define DOCSERVICE_SRV_DESCR  'docservice description'
#define DOCSERVICE_SRV_DIR    '{app}\server\docservice\sources'

#define GC_SRV        'ds_gc'
#define GC_SRV_DESCR  'gc description'
#define GC_SRV_DIR    '{app}\server\docservice\sources'

#define SPELLCHECKER_SRV        'ds_spellchecker'
#define SPELLCHECKER_SRV_DESCR  'spelchecker description'
#define SPELLCHECKER_SRV_DIR    '{app}\server\SpellChecker\sources'



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

[Dirs]
Name: {commonappdata}\{#APP_PATH}\webdata\cloud; Flags: uninsalwaysuninstall

[Files]
Source: ..\common\documentserver\home\*;           DestDir: {app}; Flags: ignoreversion recursesubdirs
Source: ..\common\documentserver\bin\*.bat;           DestDir: {app}\bin; Flags: ignoreversion recursesubdirs

[Run]
Filename: "{app}\bin\documentserver-generate-allfonts.bat";

Filename: "{#NSSM}"; Parameters: "install {#CONVERTER_SRV} node {#CONVERTER_SRV_DIR}\convertermaster.js";
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} Description {#CONVERTER_SRV_DESCR}";
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppDirectory {#CONVERTER_SRV_DIR}";
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"
Filename: "{#NSSM}"; Parameters: "start {#CONVERTER_SRV}";

Filename: "{#NSSM}"; Parameters: "install {#DOCSERVICE_SRV} node {#DOCSERVICE_SRV_DIR}\server.js";
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} Description {#DOCSERVICE_SRV_DESCR}";
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppDirectory {#DOCSERVICE_SRV_DIR}";
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"
Filename: "{#NSSM}"; Parameters: "start {#DOCSERVICE_SRV}";

Filename: "{#NSSM}"; Parameters: "install {#GC_SRV} node {#GC_SRV_DIR}\gc.js";
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} Description {#GC_SRV_DESCR}";
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppDirectory {#GC_SRV_DIR}";
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"
Filename: "{#NSSM}"; Parameters: "start {#GC_SRV}";

Filename: "{#NSSM}"; Parameters: "install {#SPELLCHECKER_SRV} node {#SPELLCHECKER_SRV_DIR}\server.js";
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} Description {#SPELLCHECKER_SRV_DESCR}";
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppDirectory {#SPELLCHECKER_SRV_DIR}";
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"
Filename: "{#NSSM}"; Parameters: "start {#SPELLCHECKER_SRV}";

[UninstallRun]
Filename: "{#NSSM}"; Parameters: "stop {#CONVERTER_SRV}"
Filename: "{#NSSM}"; Parameters: "remove {#CONVERTER_SRV} confirm"

Filename: "{#NSSM}"; Parameters: "stop {#DOCSERVICE_SRV}"
Filename: "{#NSSM}"; Parameters: "remove {#DOCSERVICE_SRV} confirm"

Filename: "{#NSSM}"; Parameters: "stop {#GC_SRV}"
Filename: "{#NSSM}"; Parameters: "remove {#GC_SRV} confirm"

Filename: "{#NSSM}"; Parameters: "stop {#SPELLCHECKER_SRV}"
Filename: "{#NSSM}"; Parameters: "remove {#SPELLCHECKER_SRV} confirm"

[UninstallDelete]
Type: filesandordirs; Name: "{app}\*"
