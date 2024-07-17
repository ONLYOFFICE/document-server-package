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
set "charset=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
set "strLength=10"
set "randomString="

for /L %%i in (1,1,%strLength%) do (
    set /a "index=!random! %% 62"
    for %%j in (!index!) do (
        set "char=!charset:~%%j,1!"
        set "randomString=!randomString!!char!"
    )
)
echo !randomString!> "%TEMP%\random_string.txt"
endlocal

set /p randomString=<"%TEMP%\random_string.txt"
set "REWRITE_RULE=rewrite ^^(?^<cache^>\/web-apps\/apps\/(?!api\/).*)$ $the_scheme://$the_host$the_prefix/%randomString%$cache redirect;"
set "LOCATION_BLOCK=location /%randomString%/ {proxy_pass http://docservice/;}"
if exist "%~dp0\..\nginx\conf\includes\ds-cache.conf" (
    del "%~dp0\..\nginx\conf\includes\ds-cache.conf"
)

echo %REWRITE_RULE% >> "%~dp0\..\nginx\conf\includes\ds-cache.conf"
echo %LOCATION_BLOCK% >> "%~dp0\..\nginx\conf\includes\ds-cache.conf"

net stop DsProxySvc
net start DsProxySvc
