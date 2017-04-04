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
  "%windir%\Fonts" ^
  "%~dp0\..\sdkjs\common\AllFonts.js" ^
  "%~dp0\..\sdkjs\common\Images" ^
  "%~dp0\..\server\FileConverter\bin\font_selection.bin"

ECHO Done

rem Restart web-site and converter
IF NOT "%ONLYOFFICE_DATA_CONTAINER%"=="true" (  
  net stop DsDocServiceSvc
  net start DsDocServiceSvc

  net stop DsConverterSvc
  net start DsConverterSvc
)
