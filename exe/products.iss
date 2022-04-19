[Code]

procedure rabbitmq;
begin
  if (FileExists(ExpandConstant('{pf}{\}RabbitMQ Server{\}rabbitmq_server-3.8.9{\}sbin{\}rabbitmq-server.bat'))) then
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

procedure redis;
begin
  if (FileExists(ExpandConstant('{pf}{\}Redis{\}redis-server.exe'))) then
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

procedure erlang;
begin
  if (FileExists(ExpandConstant('{pf}{\}erl-23.1{\}bin{\}erl.exe'))) then
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



[Setup]
