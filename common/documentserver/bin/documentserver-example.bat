@echo off
setlocal

REM Check argument
if "%~1"=="" goto usage

if /I "%~1"=="start" goto run
if /I "%~1"=="stop" goto run
if /I "%~1"=="status" goto status

goto usage

:run

sc %~1 DsExampleSvc
exit /b %errorlevel%

:status
sc query DsExampleSvc
exit /b %errorlevel%

:usage
echo Usage: %~nx0 {start^|stop^|status} 1>&2
exit /b 1