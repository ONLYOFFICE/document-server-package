@ECHO off

SET ONLYOFFICE_DATA_CONTAINER=false
IF NOT "%1"=="" (
  SET ONLYOFFICE_DATA_CONTAINER=%1
)
rem Setup path env to enable to load the dlls
set PATH=%~dp0\..\server\FileConverter\bin;%PATH%

rem Start generate AllFonts.js, font thumbnails and font_selection.bin
ECHO | SET /p="Generating AllFonts.js, please wait..."

"%~dp0\..\server\tools\AllFontsGen.exe" ^
  --input="%~dp0\..\core-fonts" ^
  --allfonts-web="%~dp0\..\sdkjs\common\AllFonts.js" ^
  --allfonts="%~dp0\..\server\FileConverter\bin\AllFonts.js" ^
  --images="%~dp0\..\sdkjs\common\Images" ^
  --selection="%~dp0\FileConverter\bin\font_selection.bin" ^
  --output-web="%~dp0\..\fonts" ^
  --use-system="true"

ECHO Done

rem Restart web-site and converter
IF NOT "%ONLYOFFICE_DATA_CONTAINER%"=="true" (  
  net stop DsDocServiceSvc
  net start DsDocServiceSvc

  net stop DsConverterSvc
  net start DsConverterSvc
)
