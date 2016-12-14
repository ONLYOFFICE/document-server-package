SET NODE_ENV=production-windows
SET NODE_CONFIG_DIR=%~dp0..\config
CD /D "%~dp0..\server\DocService\sources"
CALL node shutdown.js
CD /D "%~dp0"