@echo off
rem Host-side AdminPanel CLI wrapper - Windows counterpart of documentserver-admin.sh.
setlocal

set "DIR=%~dp0.."
set "ADMINPANEL=%DIR%\server\AdminPanel\server\adminpanel.exe"

if not exist "%ADMINPANEL%" (
  echo Admin Panel binary not found at %ADMINPANEL%. The installation may be incomplete. 1>&2
  exit /b 1
)

if not defined NODE_ENV set "NODE_ENV=production-windows"
if not defined NODE_CONFIG_DIR set "NODE_CONFIG_DIR=%DIR%\config"

cd /d "%DIR%\server\AdminPanel"

"%ADMINPANEL%" --cli %*
