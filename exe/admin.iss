#define ADMINPANEL_SRV        'DsAdminPanelSvc'
#define ADMINPANEL_SRV_DISPLAY  str(sAppName + " AdminPanel")
#define ADMINPANEL_SRV_DESCR  str(sAppName + " AdminPanel Service")
#define ADMINPANEL_SRV_DIR    '{app}\server\AdminPanel'
#define ADMINPANEL_SRV_LOG_DIR    '{app}\Log\adminpanel'
#define ADMINPANEL_SRV_FILE '{app}\winsw\AdminPanel.xml'

[Files]
Source: ..\common\documentserver\home\server\AdminPanel\*; DestDir: {app}\server\AdminPanel; Flags: ignoreversion recursesubdirs; Components: Program
Source: {#file "winsw\AdminPanel.xml"};                    DestDir: "{app}\winsw"; Flags: ignoreversion; DestName: "AdminPanel.xml"

[Dirs]
Name: "{#ADMINPANEL_SRV_LOG_DIR}";    Permissions: service-modify

[Run]
Filename: "{#WINSW}";   Parameters: "install ""{#ADMINPANEL_SRV_FILE}"""; Flags: runhidden; StatusMsg: "{cm:InstallSrv,{#ADMINPANEL_SRV}}"
Filename: "{#WINSW}";   Parameters: "start ""{#ADMINPANEL_SRV_FILE}""";   Flags: runhidden; StatusMsg: "{cm:StartSrv,{#ADMINPANEL_SRV}}"

[UninstallRun]
Filename: "{#WINSW}"; Parameters: "stop ""{#ADMINPANEL_SRV_FILE}"""; Flags: runhidden
Filename: "{#WINSW}"; Parameters: "uninstall ""{#ADMINPANEL_SRV_FILE}"""; Flags: runhidden
