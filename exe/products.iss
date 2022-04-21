[Code]
procedure Dependency_AddErlang;
begin
  if not (FileExists(ExpandConstant('{pf}{\}erl-23.1{\}bin{\}erl.exe'))) then
  begin
    Dependency_Add(
      'erlang.exe',
      '',
      'Erlang 23.1 x64',
      Dependency_String(
        '',
        'http://erlang.org/download/otp_win64_23.1.exe'
      ),
      '',
      False,
      False
    );
  end;
end;

procedure Dependency_AddRabbitMq;
begin
  if not (FileExists(ExpandConstant('{pf}{\}RabbitMQ Server{\}rabbitmq_server-3.8.9{\}sbin{\}rabbitmq-server.bat'))) then
  begin
    Dependency_Add(
      'rabbitmq-server.exe',
      '',
      'RabbitMQ 3.8.9 ',
      Dependency_String(
        '',
        'http://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.9/rabbitmq-server-3.8.9.exe'
      ),
      '',
      False,
      False
    );
  end;
end;

procedure Dependency_AddRedis;
begin
  if not (FileExists(ExpandConstant('{pf}{\}Redis{\}redis-server.exe'))) then
  begin
    Dependency_Add(
      'redis.msi',
      '/qb',
      'Redis 3.0.504 x64',
      Dependency_String(
        '',
        'http://download.onlyoffice.com/install/windows/redist/Redis-x64-3.0.504.msi'
      ),
      '',
      False,
      False
    );
  end;
end;

procedure Dependency_AddPostgreSQL;
begin
  if not (FileExists(ExpandConstant('{pf64}{\}postgresql{\}9.5{\}bin{\}postgres.exe'))) then
  begin
    Dependency_Add(
      'postgresql.exe',
      '--unattendedmodeui minimal',
      'PostgreSQL 9.5.4.1 x64',
      Dependency_String(
        '',
        'http://get.enterprisedb.com/postgresql/postgresql-9.5.4-1-windows-x64.exe'
        ),
      '',
      False,
      False
    );
  end;
end;

procedure Dependency_AddPython3;
var
  Version: String;
begin
  Version := '3.9.9';
  if not IsMsiProductInstalled(
           Dependency_String(
            '{B0D35164-DCE0-5CD6-B3AE-55F0AE08E42E}',
            '{0D8FFA35-4E68-56AE-9C6D-7B33F2B22892}'),
            StrToInt(Version)) then 
  begin
    Dependency_Add(
      'python ' + Version + Dependency_ArchSuffix + '.exe',
      'PrependPath=1 DefaultJustForMeTargetDir=' + ExpandConstant('{sd}') + '\Python  /passive /norestart',
      'Python ' + Version + Dependency_ArchTitle,
      Dependency_String(
        'http://www.python.org/ftp/python/' + Version + '/python-' + Version + '.exe',
        'http://www.python.org/ftp/python/' + Version + '/python-' + Version + '-amd64.exe'
      ),
      '',
      False,
      False
    );
  end;
end;

[Setup]
