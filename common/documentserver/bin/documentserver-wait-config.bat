
rem This script in checking document-server status, and after check passed removing maintenance page
rem

@echo off

set "MAINTENANCE_NGINX_CONF=..\nginx\conf\includes\ds-0maintenance.conf" 
set "SERVER_URL=http://localhost:8000/healthcheck"
set /a "timer=1"

:loop
   for /f "delims=" %%a in ('
       curl -s -o nul -w "%%{http_code}" %SERVER_URL%
   ') do set "status=%%a"&set "timer=%timer%+1"

   if not "%status%"=="200" ( 
        if not "%timer%"=="40" (
       echo Server not reachable... trying again...
        ) 
   )
   else ( 
      echo Server reachable! Success! 
      del "%MAINTENANCE_NGINX_CONF%" 
      goto :continue
  ) 
  timeout /t 5 /nobreak 
  goto :loop 

:continue
