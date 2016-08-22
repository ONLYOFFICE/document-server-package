#define sAppName            'ONLYOFFICE Document Server'
#define APP_PATH            'ONLYOFFICE\DocumentServer'
#define APP_REG_PATH        'Software\ONLYOFFICE\DocumentServer'
#define NAME_EXE_OUT        'DocumentServer.exe'
#define iconsExe            'projicons.exe'

#define sAppVersion         '4.0.4'
#define sAppVerShort

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
Source: ..\..\server\build\*;           DestDir: {app}; Flags: ignoreversion recursesubdirs
Source: ..\..\web-apps\deploy\*;           DestDir: {app}; Flags: ignoreversion recursesubdirs

[UninstallDelete]
Type: filesandordirs; Name: {commonappdata}\{#APP_PATH}\*;