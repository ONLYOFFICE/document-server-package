@ECHO off

SET ONLYOFFICE_DATA_CONTAINER=false
IF NOT "%1"=="" (
  SET ONLYOFFICE_DATA_CONTAINER=%1
)

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
