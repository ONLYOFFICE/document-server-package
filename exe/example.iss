#define EXAMPLE_SRV        'DsExampleSvc'
#define EXAMPLE_SRV_DISPLAY  str(sAppName + " Example")
#define EXAMPLE_SRV_DESCR  str(sAppName + " Example Service")
#define EXAMPLE_SRV_DIR    '{app}\example'
#define EXAMPLE_SRV_LOG_DIR    '{app}\Log\example'

#define NODE_EXAMPLE_SRV_ENV  'NODE_ENV=production-windows NODE_CONFIG_DIR=""{app}\example\config"" NODE_DISABLE_COLORS=1'

#define JSON_EXAMPLE_PARAMS '-I -q -f ""{app}\example\config\local.json""'

[CustomMessages]
OpenDemo=Open {#sAppName} demo
OpenWelcome=Open {#sAppName} welcome page

[Files]
Source: ..\common\documentserver-example\home\*;      DestDir: {app}\example; Flags: ignoreversion recursesubdirs
Source: ..\common\documentserver-example\config\*;    DestDir: {app}\example\config; Flags: ignoreversion recursesubdirs; Permissions: users-readexec
Source: local\local.json;                             DestDir: {app}\example\config; Flags: onlyifdoesntexist uninsneveruninstall
Source: ..\common\documentserver-example\nginx\*;     DestDir: {#NGINX_SRV_DIR}\conf; Flags: ignoreversion recursesubdirs

[Dirs]
Name: "{app}\example\files";   Permissions: users-modify
Name: "{#EXAMPLE_SRV_LOG_DIR}";       Permissions: users-modify

[Icons]
Name: "{group}\{cm:OpenDemo}"; Filename: "http://localhost:{code:GetDefaultPort}/example"

[Registry]
Root: HKLM; Subkey: "{#sAppRegPath}"; ValueType: "string"; ValueName: "{#REG_EXAMPLE_PORT}"; ValueData: "{code:GetExamplePort}"; Check: not IsStringEmpty(ExpandConstant('{param:EXAMPLE_PORT}'));

[Run]
Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""if(this.server===undefined)this.server={{token:{{}};"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"

Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""this.server.port = '{code:GetExamplePort}'"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"

Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""this.server.token.enable = {code:GetJwtEnabled}"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"
Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""this.server.token.secret = '{code:GetJwtSecret}'"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"
Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""this.server.token.authorizationHeader = '{code:GetJwtHeader}'"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"

Filename: "{#NSSM}"; Parameters: "install {#EXAMPLE_SRV} ""{#EXAMPLE_SRV_DIR}\example.exe"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} DisplayName {#EXAMPLE_SRV_DISPLAY}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} Description {#EXAMPLE_SRV_DESCR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppDirectory {#EXAMPLE_SRV_DIR}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppEnvironmentExtra {#NODE_EXAMPLE_SRV_ENV}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppRotateFiles 1"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppRotateOnline 1"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppRotateBytes {#LOG_ROTATE_BYTES}"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppStdout {#EXAMPLE_SRV_LOG_DIR}\out.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} AppStderr {#EXAMPLE_SRV_LOG_DIR}\error.log"; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} ObjectName ""{#LOCAL_SERVICE}"" """" "; Flags: runhidden; StatusMsg: "{cm:CfgSrv,{#EXAMPLE_SRV}}"
Filename: "{#NSSM}"; Parameters: "set {#EXAMPLE_SRV} Start SERVICE_DEMAND_START"; Flags: runhidden; StatusMsg: "{cm:StartSrv,{#EXAMPLE_SRV}}"


Filename: "http://localhost:{code:GetDefaultPort}/welcome/"; Description: "{cm:OpenWelcome}"; Flags: postinstall shellexec skipifsilent

[UninstallRun]
Filename: "{#NSSM}"; Parameters: "stop {#EXAMPLE_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#EXAMPLE_SRV} confirm"; Flags: runhidden


