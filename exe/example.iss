#define EXAMPLE_SRV        'DsExampleSvc'
#define EXAMPLE_SRV_DISPLAY  'ONLYOFFICE DocumentServer Example'
#define EXAMPLE_SRV_DESCR  'ONLYOFFICE DocumentServer Example Service'
#define EXAMPLE_SRV_DIR    '{app}\example'
#define EXAMPLE_SRV_LOG_DIR    '{app}\Log\example'

#define NODE_EXAMPLE_SRV_ENV  'NODE_ENV=production-windows NODE_CONFIG_DIR=""{app}\example\config"" NODE_DISABLE_COLORS=1'

#define JSON_EXAMPLE_PARAMS '-I -q -f ""{app}\example\config\default.json""'

[CustomMessages]
OpenDemo=Open {#sAppName} demo
OpenWelcome=Open {#sAppName} welcome page

[Files]
Source: ..\common\documentserver-example\home\*;      DestDir: {app}\example; Flags: ignoreversion recursesubdirs
Source: ..\common\documentserver-example\config\*;    DestDir: {app}\example\config; Flags: ignoreversion recursesubdirs
Source: ..\common\documentserver-example\nginx\*;     DestDir: {#NGINX_SRV_DIR}\conf; Flags: ignoreversion recursesubdirs

[Dirs]
Name: "{app}\example\public\files";   Permissions: users-modify
Name: "{#EXAMPLE_SRV_LOG_DIR}";       Permissions: users-modify

[Icons]
Name: "{group}\{cm:OpenDemo}"; Filename: "http://localhost/example"

[Registry]
Root: HKLM; Subkey: "{#APP_REG_PATH}"; ValueType: "string"; ValueName: "{#REG_EXAMPLE_PORT}"; ValueData: "{code:GetExamplePort}";

[Run]
Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""this.server.port = '{code:GetExamplePort}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"

Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""this.server.token.enable = {code:GetJwtEnabled}"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"
Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""this.server.token.secret = '{code:GetJwtSecret}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"
Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""this.server.token.authorizationHeader = '{code:GetJwtHeader}'"""; WorkingDir: "{#NODE_PATH}"; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"

Filename: "{#NSSM}"; Parameters: "install {#EXAMPLE_SRV} node .\bin\www"; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} DisplayName {#EXAMPLE_SRV_DISPLAY}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} Description {#EXAMPLE_SRV_DESCR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppDirectory {#EXAMPLE_SRV_DIR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppEnvironmentExtra {#NODE_EXAMPLE_SRV_ENV}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppStdout {#EXAMPLE_SRV_LOG_DIR}\out.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppStderr {#EXAMPLE_SRV_LOG_DIR}\error.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} ObjectName ""{#LOCAL_SERVICE}"" """" "; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} Start SERVICE_DEMAND_START"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#EXAMPLE_SRV}}"

Filename: "http://localhost/welcome"; Description: "{cm:OpenWelcome}"; Flags: postinstall shellexec skipifsilent

[UninstallRun]
Filename: "{#NSSM}"; Parameters: "stop {#EXAMPLE_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#EXAMPLE_SRV} confirm"; Flags: runhidden

