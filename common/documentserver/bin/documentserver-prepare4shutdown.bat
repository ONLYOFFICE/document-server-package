@ECHO off
SET NODE_ENV=production-windows
SET NODE_CONFIG_DIR=%~dp0..\config
CD /D "%~dp0..\server\DocService\sources"

ECHO | SET /p="Preparing for shutdown, it can take a lot of time, please wait..."
CALL node shutdown.js
ECHO Done

CD /D "%~dp0"