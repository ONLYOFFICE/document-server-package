@echo off
set "SCRIPT_PATH=%~dp0"
:parse_args
IF "%1"=="" goto :done

IF "%1"=="-r" (
  set "RESTART_CONDITION=%2"
  SHIFT
  SHIFT
  goto :parse_args
)

IF "%1"=="-h" (
  set "HASH=%2"
  SHIFT
  SHIFT
  goto :parse_args
)
:done

REM Generate a unique number based on the current date and time
set "datetime=%date:~10,4%.%date:~4,2%.%date:~7,2%-%time:~0,2%%time:~3,2%"

REM Save datetime to a file in the temp folder
set "tempFile=%temp%\datetime.txt"

IF "%HASH%"=="" (
  echo %datetime% > "%tempFile%"

  REM Compute the hash of the file using certutil
  for /f "tokens=*" %%A in ('certutil -hashfile "%tempFile%" MD5 ^| findstr /v /c:"CertUtil"') do (
    set "hash=%%A"
  )
)

REM Append the cache_tag setting to ds-cache.conf
echo set $cache_tag "%HASH%"; > "%SCRIPT_PATH%\..\nginx\conf\includes\ds-cache.conf"

copy /y "%SCRIPT_PATH%\..\web-apps\apps\api\documents\api.js.tpl" "%SCRIPT_PATH%\..\web-apps\apps\api\documents\api.js"
"%SCRIPT_PATH%\..\npm\replace.exe" "{{HASH_POSTFIX}}" "%HASH%" "%SCRIPT_PATH%\..\web-apps\apps\api\documents\api.js"

rem Restart web-site and converter
IF NOT "%RESTART_CONDITION%"=="false" (  
  net stop DsProxySvc
  net start DsProxySvc
)
