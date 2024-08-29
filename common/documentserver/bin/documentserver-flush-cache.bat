@echo off
IF NOT "%1"=="" (
  SET RESTART_CONDITION=%1
)
setlocal enabledelayedexpansion

REM Generate a unique number based on the current date and time
set "datetime=%date:~10,4%.%date:~4,2%.%date:~7,2%-%time:~0,2%%time:~3,2%"

REM Save datetime to a file in the temp folder
set "tempFile=%temp%\datetime.txt"
echo %datetime% > "%tempFile%"

REM Compute the hash of the file using certutil
for /f "tokens=*" %%A in ('certutil -hashfile "%tempFile%" MD5 ^| findstr /v /c:"CertUtil"') do (
    set "hash=%%A"
)

REM Append the cache_tag setting to ds-cache.conf
echo set $cache_tag "%hash%"; > "%~dp0\..\nginx\conf\includes\ds-cache.conf"

copy /y "%~dp0\..\web-apps\apps\api\documents\api.js.tpl" "%~dp0\..\web-apps\apps\api\documents\api.js"
"%~dp0\..\npm\replace.exe" "{{HASH_POSTFIX}}" "%hash%" "%~dp0\..\web-apps\apps\api\documents\api.js"

endlocal

rem Restart web-site and converter
IF NOT "%RESTART_CONDITION%"=="false" (  
  net stop DsProxySvc
  net start DsProxySvc
)
