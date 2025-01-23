; -- Prerequisites Installer --

#define EDITION "prerequisites"

#ifndef VERSION
#define VERSION '0.0.0.0'
#endif

#ifndef BRANDING_DIR
#define BRANDING_DIR '.'
#endif

#include BRANDING_DIR + '\defines.iss'

#define sEditionName "Prerequisites"

#ifndef sPackageName
#define sPackageName sIntCompanyName + '-' + sIntProductName + '-' + sEditionName
#endif

#define public Dependency_NoExampleSetup
#include "InnoDependencyInstaller\CodeDependencies.iss"
#include "products.iss"

[Setup]
AppName                   ={#sAppName} {#sEditionName}
AppId                     ={#sAppId} {#sEditionName}
AppVerName                ={#sAppName} {#sEditionName}
OutputBaseFilename        ={#sPackageName}-{#VERSION}-x64

AppPublisher            ={#sPublisherName}
AppPublisherURL         ={#sPublisherUrl}
AppSupportURL           ={#sSupportURL}
AppUpdatesURL           ={#sUpdatesURL}
AppCopyright            ={#sAppCopyright}

ArchitecturesAllowed              =x64
ArchitecturesInstallIn64BitMode   =x64compatible

Uninstallable             = no
CreateAppDir              = no
DisableReadyPage          = no
DisableProgramGroupPage   = yes
DisableWelcomePage        = no
DisableDirPage            = yes
AllowNoIcons              = yes
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
en.Program=Program components
ru.Program=Компоненты программы

en.Prerequisites=Install prerequisites
ru.Prerequisites=Установить необходимое ПО

en.FullInstall=Full installation
ru.FullInstall=Полная установка

en.CompactInstall=Compact installation
ru.CompactInstall=Компактная установка

en.CustomInstall=Custom installation
ru.CustomInstall=Выборочная установка

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"

[Files]
Source: "redist\postgresql-12.17-1-windows-x64.exe"; DestDir: "{tmp}"; Flags: noencryption deleteafterinstall
Source: "redist\certbot-2.6.0.exe"; DestDir: "{tmp}"; Flags: noencryption deleteafterinstall
Source: "redist\Redis-x64-5.0.10.msi"; DestDir: "{tmp}"; Flags: noencryption deleteafterinstall
Source: "redist\otp_win64_26.2.1.exe"; DestDir: "{tmp}"; Flags: noencryption deleteafterinstall
Source: "redist\rabbitmq-server-3.12.11.exe"; DestDir: "{tmp}"; Flags: noencryption deleteafterinstall
Source: "redist\FireDaemon-OpenSSL-x64-3.3.0.exe"; DestDir: "{tmp}"; Flags: noencryption deleteafterinstall
Source: "redist\python-3.11.3-amd64.exe"; DestDir: "{tmp}"; Flags: noencryption deleteafterinstall
Source: "redist\vcredist2013_x64.exe"; DestDir: "{tmp}"; Flags: noencryption deleteafterinstall
Source: "redist\vcredist2022_x64.exe"; DestDir: "{tmp}"; Flags: noencryption deleteafterinstall

[Types]
Name: full; Description: {cm:FullInstall}
Name: compact; Description: {cm:CompactInstall}
Name: custom; Description: {cm:CustomInstall}; Flags: iscustom

[Components]
Name: "Program"; Description: "{cm:Program}"; Types: full compact custom; Flags: fixed
Name: "Prerequisites"; Description: "{cm:Prerequisites}"; Types: full
Name: "Prerequisites\Certbot"; Description: "Certbot"; Flags: checkablealone; Types: full; Check: not IsCertbotInstalled;
Name: "Prerequisites\OpenSSL"; Description: "OpenSSL"; Flags: checkablealone; Types: full custom compact; Check: not IsOpenSSLInstalled;
Name: "Prerequisites\Python"; Description: "Python 3.11.3 "; Flags: checkablealone; Types: full; Check: not IsPythonInstalled;
Name: "Prerequisites\PostgreSQL"; Description: "PostgreSQL 12.17"; Flags: checkablealone; Types: full; Check: not IsPostgreSQLInstalled;
Name: "Prerequisites\RabbitMq"; Description: "RabbitMQ 3.12.11"; Flags: checkablealone; Types: full; Check: not IsRabbitMQInstalled;
Name: "Prerequisites\Redis"; Description: "Redis 5.0.10"; Flags: checkablealone; Types: full; Check:not IsRedisInstalled;
Name: "Prerequisites\VC2013"; Description: "Visual C++ 2013 Update 5 Redistributable"; Flags: checkablealone; Types: full; Check: not IsVC2013Installed;
Name: "Prerequisites\VC2022"; Description: "Visual C++ 2015-2022 Redistributable"; Flags: checkablealone; Types: full; Check:not IsVC2015To2022Installed;

[Code]
function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := true;
  if WizardSilent() = false then
  begin
    case CurPageID of
      wpWelcome:
        Result := true;
      wpSelectComponents:
      begin
        if WizardIsComponentSelected('Prerequisites\Redis') then
        begin
          Dependency_AddBundledRedis;
        end;
        if WizardIsComponentSelected('Prerequisites\RabbitMq') then
        begin
          Dependency_AddBundledErlang;
          Dependency_AddBundledRabbitMq;
        end;
        if WizardIsComponentSelected('Prerequisites\PostgreSQL') then
        begin
          Dependency_AddBundledPostgreSQL;
        end;
        if WizardIsComponentSelected('Prerequisites\Certbot') then
        begin
          Dependency_AddBundledCertbot;
        end;
        if WizardIsComponentSelected('Prerequisites\Python') then
        begin
          Dependency_AddBundledPython3;
        end;
        if WizardIsComponentSelected('Prerequisites\OpenSSL') then
        begin
          Dependency_AddBundledOpenSSL;
        end;
        if WizardIsComponentSelected('Prerequisites\VC2013') then
        begin
          Dependency_AddBundledVC2013;
        end;
        if WizardIsComponentSelected('Prerequisites\VC2022') then
        begin
          Dependency_AddBundledVC2015To2022;
        end;
       end;
    end;
  end;
end;

