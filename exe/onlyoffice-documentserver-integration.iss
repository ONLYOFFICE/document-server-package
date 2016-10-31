#define sPackageName        'onlyoffice-documentserver-integration'

#include "common.iss"

#define REG_EXAMPLE_PORT        'ExamplePort'

#define EXAMPLE_SRV        'DsExampleSvc'
#define EXAMPLE_SRV_DISPLAY  'ONLYOFFICE DocumentServer Example'
#define EXAMPLE_SRV_DESCR  'ONLYOFFICE DocumentServer Example Service'
#define EXAMPLE_SRV_DIR    '{app}\example'
#define EXAMPLE_SRV_LOG_DIR    '{app}\Log\example'

#define NODE_EXAMPLE_SRV_ENV  'NODE_ENV=production-windows NODE_CONFIG_DIR=""{app}\example\config"" NODE_DISABLE_COLORS=1'

#define JSON_EXAMPLE_PARAMS '-I -q -f ""{app}\example\config\default.json""'

[Files]
Source: ..\common\documentserver-example\home\*;      DestDir: {app}\example; Flags: ignoreversion recursesubdirs
Source: ..\common\documentserver-example\config\*;    DestDir: {app}\example\config; Flags: ignoreversion recursesubdirs
Source: nginx\onlyoffice-documentserver-example.conf; DestDir: {#NGINX_SRV_DIR}\conf; Flags: ignoreversion recursesubdirs

[Dirs]
Name: "{app}\example\public\files";   Permissions: users-full
Name: "{#EXAMPLE_SRV_LOG_DIR}";       Permissions: users-full

[Icons]
Name: "{group}\Open {#sAppName} demo"; Filename: "http://localhost/example"

[Registry]
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_EXAMPLE_PORT}"; ValueData: "{code:GetExamplePort}";

[Run]
Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""this.server.port = '{code:GetExamplePort}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden

Filename: "{#REPLACE}"; Parameters: "{{{{EXAMPLE_PORT}} {code:GetExamplePort} ""{#NGINX_SRV_DIR}\conf\onlyoffice-documentserver-example.conf"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "install {#EXAMPLE_SRV} node .\bin\www"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} DisplayName {#EXAMPLE_SRV_DISPLAY}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} Description {#EXAMPLE_SRV_DESCR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppDirectory {#EXAMPLE_SRV_DIR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppEnvironmentExtra {#NODE_EXAMPLE_SRV_ENV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppStdout {#EXAMPLE_SRV_LOG_DIR}\out.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppStderr {#EXAMPLE_SRV_LOG_DIR}\error.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "start {#EXAMPLE_SRV}"; Flags: runhidden

Filename: "http://localhost/example"; Description: "Open {#sAppName} demo"; Flags: postinstall shellexec skipifsilent

[UninstallRun]
Filename: "{#NSSM}"; Parameters: "stop {#EXAMPLE_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#EXAMPLE_SRV} confirm"; Flags: runhidden

[Code]
procedure StopDsServices;
begin
  StopSrv(ExpandConstant('{#NGINX_SRV}'));
  StopSrv(ExpandConstant('{#CONVERTER_SRV}'));
  StopSrv(ExpandConstant('{#DOCSERVICE_SRV}'));
  StopSrv(ExpandConstant('{#GC_SRV}'));
  StopSrv(ExpandConstant('{#SPELLCHECKER_SRV}'));
  StopSrv(ExpandConstant('{#EXAMPLE_SRV}'));
end;

function GetExamplePort(Param: String): String;
begin
  Result := ExpandConstant('{param:EXAMPLE_PORT|{reg:HKLM\{#APP_REG_PATH},{#REG_EXAMPLE_PORT}|3000}}');
end;
