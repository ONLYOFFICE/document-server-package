@echo off

rem Setup path env to enable to load the dlls
set PATH=%~dp0\..\server\FileConverter\bin;%PATH%

set PLUGIN_MANAGER=%~dp0\..\server\tools\pluginsmanager.exe
set PLUGIN_DIR=%~dp0\..\sdkjs-plugins

if not "%1"=="" (
 if /i "%1"=="-r" (
    set RESTART_CONDITION=%2
    shift
    shift
   )
)

call "%PLUGIN_MANAGER%" --directory="%PLUGIN_DIR%" %*

rem Restart web-site
IF NOT "%RESTART_CONDITION%"=="false" (
  net stop DsDocServiceSvc
  net start DsDocServiceSvc
  call "%~dp0\documentserver-flush-cache.bat"
)