@ECHO off

SET ONLYOFFICE_DATA_CONTAINER=false
IF NOT "%1"=="" (
  SET ONLYOFFICE_DATA_CONTAINER=%1
)
rem Setup path env to enable to load the dlls
set PATH=%~dp0\..\server\FileConverter\bin;%PATH%

rem Start generate AllFonts.js, font thumbnails and font_selection.bin
ECHO | SET /p="Generating AllFonts.js, please wait..."

"%~dp0\..\server\tools\allfontsgen.exe" ^
  --input="%~dp0\..\core-fonts" ^
  --allfonts-web="%~dp0\..\sdkjs\common\AllFonts.js" ^
  --allfonts="%~dp0\..\server\FileConverter\bin\AllFonts.js" ^
  --images="%~dp0\..\sdkjs\common\Images" ^
  --selection="%~dp0\..\server\FileConverter\bin\font_selection.bin" ^
  --output-web="%~dp0\..\fonts" ^
  --use-system="true" ^
  --use-system-user-fonts="false"

ECHO Done

ECHO | SET /p="Generating presentation themes, please wait..."
"%~dp0\..\server\tools\allthemesgen.exe" ^
  --converter-dir="%~dp0\..\server\FileConverter\bin" ^
  --src="%~dp0\..\sdkjs\slide\themes" ^
  --output="%~dp0\..\sdkjs\common\Images"

"%~dp0\..\server\tools\allthemesgen.exe" ^
  --converter-dir="%~dp0\..\server\FileConverter\bin" ^
  --src="%~dp0\..\sdkjs\slide\themes" ^
  --output="%~dp0\..\sdkjs\common\Images" ^
  --postfix="ios" ^
  --params="280,224"

"%~dp0\..\server\tools\allthemesgen.exe" ^
  --converter-dir="%~dp0\..\server\FileConverter\bin" ^
  --src="%~dp0\..\sdkjs\slide\themes" ^
  --output="%~dp0\..\sdkjs\common\Images" ^
  --postfix="android" ^
  --params="280,224"

ECHO Done

ECHO | SET /p="Generating js caches, please wait..."

"%~dp0\..\server\FileConverter\bin\x2t.exe" -create-js-cache

ECHO Done

rem Restart web-site and converter
IF NOT "%ONLYOFFICE_DATA_CONTAINER%"=="true" (  
  net stop DsDocServiceSvc
  net start DsDocServiceSvc

  net stop DsConverterSvc
  net start DsConverterSvc
)

setlocal enabledelayedexpansion

REM Generate a unique number based on the current date and time
set "datetime=%date:~10,4%.%date:~4,2%.%date:~7,2%-%time:~0,2%%time:~3,2%%time:~6,2%"
set "datetime=%datetime: =0%"
set "datetime=%datetime::=%"

REM Append the cache_tag setting to ds-cache.conf
echo set $cache_tag "%datetime%"; > "%~dp0\..\nginx\conf\includes\ds-cache.conf"

endlocal

net stop DsProxySvc
net start DsProxySvc
