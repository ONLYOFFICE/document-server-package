@ECHO off
rem Setup path env to enable to find nssm
set PATH=%~dp0..\nssm;%PATH%

nssm rotate DsConverterSvc
nssm rotate DsDocServiceSvc
nssm rotate DsProxySvc

forfiles /p "%~dp0..\Log" /s /m out-*.log /D -30 /C "cmd /c del @path" || exit 0
forfiles /p "%~dp0..\Log" /s /m error-*.log /D -30 /C "cmd /c del @path" || exit 0
