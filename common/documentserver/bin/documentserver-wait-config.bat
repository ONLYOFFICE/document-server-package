@echo off

set "MAINTENANCE_NGINX_CONF=..\nginx\conf\includes\ds-0maintenance.conf" 
set "SERVER_URL=http://localhost:8000/healthcheck"

:loop
   for /f "delims=" %%a in ('
       curl -s -o nul -w "%%{http_code}" %SERVER_URL%
   ') do set "status=%%a"

   if not "%status%"=="200" ( 
       echo Server not reachable... trying again...
   ) else ( 
      echo Server reachable! Success! 
      del "%MAINTENANCE_NGINX_CONF%" 
      goto :continue
  ) 
  timeout /t 5 /nobreak 
  goto :loop 

:continue
