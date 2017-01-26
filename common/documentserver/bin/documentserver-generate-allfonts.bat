@ECHO off
SET ONLYOFFICE_DATA_CONTAINER=false

IF NOT "%1"=="" (
  SET ONLYOFFICE_DATA_CONTAINER=%1
)

"%~dp0\..\server\tools\AllFontsGen.exe" ^
  "%windir%\Fonts" ^
  "%~dp0\..\sdkjs\common\AllFonts.js" ^
  "%~dp0\..\sdkjs\common\Images" ^
  "%~dp0\..\server\FileConverter\bin\font_selection.bin"

IF NOT "%ONLYOFFICE_DATA_CONTAINER%"=="true" (  
  net stop DsDocServiceSvc
  net start DsDocServiceSvc

  net stop DsConverterSvc
  net start DsConverterSvc
)
