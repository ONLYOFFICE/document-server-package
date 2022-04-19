[Code]
procedure postgresql;
begin
  if (FileExists(ExpandConstant('{pf64}{\}postgresql{\}9.5{\}bin{\}postgres.exe'))) then
    Dependency_Add(
      'postgresql.exe',
      '--unattendedmodeui minimal',
      'PostgreSQL 9.5.4.1 x64',
      Dependency_String(
        '',
        'http://get.enterprisedb.com/postgresql/postgresql-9.5.4-1-windows-x64.exe'),
      '',
      False,
      False);
end;

procedure rabbitmq;
begin
  if (FileExists(ExpandConstant('{pf64}{\}RabbitMQ Server{\}rabbitmq_server-3.8.9{\}sbin{\}rabbitmq-server.bat'))) then
    Dependency_Add(
      'rabbitmq-server.exe',
      '',
      'RabbitMQ 3.8.9 ',
      Dependency_String(
        '',
        'http://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.9/rabbitmq-server-3.8.9.exe'),
      '',
      False,
      False);
end;

procedure redist;
begin
  if (FileExists(ExpandConstant('{pf64}{\}Redis{\}redis-server.exe'))) then
    Dependency_Add(
      'redis.msi',
      '/qb',
      'Redis 3.0.504 x64',
      Dependency_String(
        '',
        'http://download.onlyoffice.com/install/windows/redist/Redis-x64-3.0.504.msi'),
      '',
      False,
      False);
end;

procedure python399;
begin
  if not IsMsiProductInstalled(Dependency_String('{B0D35164-DCE0-5CD6-B3AE-55F0AE08E42E}', '{0D8FFA35-4E68-56AE-9C6D-7B33F2B22892}'), PackVersionComponents(3, 9, 9, 0)) then begin
    Dependency_Add(
      'python 3.9.9' + Dependency_ArchSuffix + '.exe',
      'PrependPath=1 DefaultJustForMeTargetDir=' + ExpandConstant('{sd}') + '\Python  /passive /norestart',
      'Python 3.9.9' + Dependency_ArchTitle,
      Dependency_String(
        'http://www.python.org/ftp/python/3.9.9/python-3.9.9.exe',
        'http://www.python.org/ftp/python/3.9.9/python-3.9.9-amd64.exe'),
      '',
      False,
      False);
  end;
end;

[Setup]
