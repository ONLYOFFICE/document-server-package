@echo off
setlocal enabledelayedexpansion
set SECURE_LINK_SECRET=%~1

if not defined SECURE_LINK_SECRET (
  set "string=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
  for /L %%i in (1,1,20) do call :add
)

set "NGINX_CONF=..\nginx\conf\includes\ds-docservice.conf"
set "DOCSERVICE_CONF=..\config\default.json"
set "JSON=json.exe -I -q -f"
set "REPLACE=replace.exe"
set "NPM_PATH=..\npm"

pushd %NPM_PATH%
  %JSON% %DOCSERVICE_CONF% -e "this.storage.fs.secretString = '%SECURE_LINK_SECRET%'"
  %REPLACE% "(set.\$secret_string.).*;" "$1%SECURE_LINK_SECRET%;" %NGINX_CONF%
popd

net stop DsDocServiceSvc
net start DsDocServiceSvc

net stop DsConverterSvc
net start DsConverterSvc

net stop DsProxySvc
net start DsProxySvc

:add
set /a x=%random% %% 62 
set SECURE_LINK_SECRET=%SECURE_LINK_SECRET%!string:~%x%,1!
goto :eof
