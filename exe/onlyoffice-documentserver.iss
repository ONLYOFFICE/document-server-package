#define sPackageName        'onlyoffice-documentserver'

#include "common.iss"

[Code]
procedure StopDsServices;
begin
  StopSrv(ExpandConstant('{#NGINX_SRV}'));
  StopSrv(ExpandConstant('{#CONVERTER_SRV}'));
  StopSrv(ExpandConstant('{#DOCSERVICE_SRV}'));
  StopSrv(ExpandConstant('{#GC_SRV}'));
  StopSrv(ExpandConstant('{#SPELLCHECKER_SRV}'));
end;