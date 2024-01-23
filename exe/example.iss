﻿#define EXAMPLE_SRV        'DsExampleSvc'
#define EXAMPLE_SRV_DISPLAY  str(sAppName + " Example")
#define EXAMPLE_SRV_DESCR  str(sAppName + " Example Service")
#define EXAMPLE_SRV_DIR    '{app}\example'
#define EXAMPLE_SRV_LOG_DIR    '{app}\Log\example'
#define EXAMPLE_SRV_FILE '{app}\winsw\Example.xml'

#define JSON_EXAMPLE_PARAMS '-I -q -f ""{app}\example\config\local.json""'

[CustomMessages]
OpenDemo=Open {#sAppName} demo
OpenWelcome=Open {#sAppName} welcome page

[Files]
Source: ..\common\documentserver-example\home\*;      DestDir: {app}\example; Flags: ignoreversion recursesubdirs
Source: ..\common\documentserver-example\config\*;    DestDir: {app}\example\config; Flags: ignoreversion recursesubdirs; Permissions: users-readexec
Source: local\local.json;                             DestDir: {app}\example\config; Flags: onlyifdoesntexist uninsneveruninstall
Source: ..\common\documentserver-example\nginx\*;     DestDir: {#NGINX_SRV_DIR}\conf; Flags: ignoreversion recursesubdirs
Source: {#file "winsw\Example.xml"};                  DestDir: "{app}\winsw"; Flags: ignoreversion; DestName: "Example.xml"

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

Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""this.server.token.enable = {code:GetJwtEnabled}"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"; Check: (not IsLocalJsonExists()) or (not IsStringEmpty(ExpandConstant('{param:JWT_ENABLED}')));
Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""this.server.token.secret = '{code:GetJwtSecret}'"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"; Check: (not IsLocalJsonExists()) or (not IsStringEmpty(ExpandConstant('{param:JWT_SECRET}')));
Filename: "{#JSON}"; Parameters: "{#JSON_EXAMPLE_PARAMS} -e ""this.server.token.authorizationHeader = '{code:GetJwtHeader}'"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"; Check: (not IsLocalJsonExists()) or (not IsStringEmpty(ExpandConstant('{param:JWT_HEADER}')));

Filename: "{#WINSW}";   Parameters: "install ""{#EXAMPLE_SRV_FILE}"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#EXAMPLE_SRV}}"

Filename: "http://localhost:{code:GetDefaultPort}/welcome/"; Description: "{cm:OpenWelcome}"; Flags: postinstall shellexec skipifsilent

[UninstallRun]
Filename: "{#WINSW}"; Parameters: "stop ""{#EXAMPLE_SRV_FILE}"""; Flags: runhidden
Filename: "{#WINSW}"; Parameters: "uninstall ""{#EXAMPLE_SRV_FILE}"""; Flags: runhidden


