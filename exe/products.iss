#define Registry32 "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\"
#define Registry64 "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"

[Code]
function IsInstalled(Regex: String; RegistryPath: String): Boolean;
var 
  ResultCode: Integer;
begin
  Result := True;
  Exec(
    'cmd.exe',
    '/c reg query ' + RegistryPath + ' | findstr /R /C:"' + Regex + '"',
    '',
    SW_HIDE,
    EwWaitUntilTerminated,
    ResultCode);
  if ResultCode <> 0 then
  begin
    Result := False;
  end;
end;

function IsRabbitMQInstalled(): Boolean;
begin
  Result := IsInstalled('RabbitMQ$', '{#Registry32}');
end;

function IsErlangInstalled(): Boolean;
begin
  Result := IsInstalled('Erlang OTP [0-9]*', '{#Registry32}');
end;

function IsPostgreSQLInstalled(): Boolean;
begin
  Result := IsInstalled('PostgreSQL [0-9].*[^a-zA-Z]$', '{#Registry64}');
end;

function IsWinAcmeInstalled(): Boolean;
var
  Version: String;
begin
  Version := '2';
  Result := IsMsiProductInstalled(
           Dependency_String(
            '',
            '{2F5D6A3A-9B1C-4E6B-9D5E-1A6E7F3D0B11}'),
            StrToInt(Version));
end;

function IsPythonInstalled(): Boolean;
var
  Version: String;
  PythonRegPath: String;
begin
  Version :=  '3.11'
  PythonRegPath := 'Software\Python\PythonCore\' + Version + '\InstallPath';
  Result := RegKeyExists(HKLM, PythonRegPath) or RegKeyExists(HKCU, PythonRegPath);
end;

function IsRedisInstalled(): Boolean;
var
  Version: String;
begin
  Version := '7';
  Result := IsMsiProductInstalled(
           Dependency_String(
            '',
            '{05410198-7212-4FC4-B7C8-AFEFC3DA0FBC}'),
            StrToInt(Version));
end;

function IsOpenSSLInstalled(): Boolean;
begin
  Result := IsInstalled('{8A79DC1B-5F6C-4C14-A33F-BD020AFD6739}', '{#Registry64}');
end;

function IsVC2013Installed(): Boolean;
begin
  Result := IsMsiProductInstalled(Dependency_String('{B59F5BF1-67C8-3802-8E59-2CE551A39FC5}', '{20400CF0-DE7C-327E-9AE4-F0F38D9085F8}'), PackVersionComponents(12, 0, 40664, 0));
end;

function IsVC2015To2022Installed(): Boolean;
begin
  Result := IsMsiProductInstalled(Dependency_String('{65E5BD06-6392-3027-8C26-853107D3CF1A}', '{36F68A90-239C-34DF-B58C-64B30153CE35}'), PackVersionComponents(14, 30, 30704, 0));
end;

procedure Dependency_AddBundledVC2013;
begin
  if IsVC2013Installed() = False then
  begin
    ExtractTemporaryFile('vcredist2013_x64.exe');
    Dependency_Add(
      'vcredist2013_x64.exe',
      '/quiet /norestart',
      'Visual C++ 2013 Update 5 Redistributable',
      '',
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddBundledVC2015To2022;
begin
  if IsVC2015To2022Installed() = False then
  begin
    ExtractTemporaryFile('vcredist2022_x64.exe');
    Dependency_Add(
      'vcredist2022_x64.exe',
      '/quiet /norestart',
      'Visual C++ 2015-2022 Redistributable',
      '',
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddBundledErlang;
begin
  if IsErlangInstalled() = False then
  begin
    ExtractTemporaryFile('otp_win64_27.3.4.6.exe');
    Dependency_Add(
      'otp_win64_27.3.4.6.exe',
      '/S',
      'Erlang 27.3.4 x64',
      '',
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddErlang;
begin
  if IsErlangInstalled() = False then
  begin
    Dependency_Add(
      'erlang.exe',
      '/S',
      'Erlang 27.3.4 x64',
      Dependency_String(
        '',
        'https://github.com/erlang/otp/releases/download/OTP-27.3.4.6/otp_win64_27.3.4.6.exe'),
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddBundledRabbitMq;
begin
  if IsRabbitMQInstalled() = False then
  begin
    ExtractTemporaryFile('rabbitmq-server-4.2.1.exe');
    Dependency_Add(
      'rabbitmq-server-4.2.1.exe',
      '/S',
      'RabbitMQ 4.2.1',
      '',
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddRabbitMq;
begin
  if IsRabbitMQInstalled() = False then
  begin
    Dependency_Add(
      'rabbitmq-server-4.2.1.exe',
      '/S',
      'RabbitMQ 4.2.1',
      Dependency_String(
        '',
        'https://github.com/rabbitmq/rabbitmq-server/releases/download/v4.2.1/rabbitmq-server-4.2.1.exe'),
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddBundledPostgreSQL;
begin
  if IsPostgreSQLInstalled() = False then
  begin
    ExtractTemporaryFile('postgresql-18.1-2-windows-x64.exe');
    Dependency_Add(
      'postgresql-18.1-2-windows-x64.exe',
      '--unattendedmodeui none --install_runtimes 0 --mode unattended',
      'PostgreSQL 18.1 x64',
      '',
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddPostgreSQL;
begin
  if IsPostgreSQLInstalled() = False then
  begin
    Dependency_Add(
      'postgresql.exe',
      '--unattendedmodeui none --install_runtimes 0 --mode unattended',
      'PostgreSQL 18.1 x64',
      Dependency_String(
        '',
        'https://get.enterprisedb.com/postgresql/postgresql-18.1-2-windows-x64.exe'),
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddBundledRedis;
var
  Version: String;
begin
  Version := '7.4.0';
  ExtractTemporaryFile('Redis-7.4.0-Windows-x64.msi');
  Dependency_Add(
    'Redis-7.4.0-Windows-x64.msi',
    '/quiet',
    'Redis ' + Version + 'x64',
    '',
    '',
    False,
    False);
end;

procedure Dependency_AddRedis;
var
  Version: String;
begin
  Version := '7.4.0';
  Dependency_Add(
    'redis.msi',
    '/quiet',
    'Redis ' + Version + 'x64',
    Dependency_String(
      '',
      'https://github.com/ONLYOFFICE/redis-windows/releases/download/7.4.0/Redis-7.4.0-Windows-x64.msi'),
    '',
    False,
    False);
end;

procedure Dependency_AddBundledPython3;
var
  Version: String;
  Patch: String;
  SemVer: String;
begin
  Version := '3.11';
  Patch := '3';
  SemVer := Version + '.' + Patch;
  ExtractTemporaryFile('python-3.11.3-amd64.exe');
  Dependency_Add(
    'python-' + SemVer + '-amd64.exe',
    'PrependPath=1 DefaultJustForMeTargetDir=' +
      ExpandConstant('{sd}') + '\Python  /quiet /norestart',
    'Python ' + Version + Dependency_ArchTitle,
    '',
    '',
    False,
    False);
end;

procedure Dependency_AddPython3;
var
  Version: String;
  Patch: String;
  SemVer: String;
begin
  Version := '3.11';
  Patch := '3';
  SemVer := Version + '.' + Patch;
  Dependency_Add(
    'python ' + Version + Dependency_ArchSuffix + '.exe',
    'PrependPath=1 DefaultJustForMeTargetDir=' +
      ExpandConstant('{sd}') + '\Python  /quiet /norestart',
    'Python ' + Version + Dependency_ArchTitle,
    Dependency_String(
      'https://www.python.org/ftp/python/' + SemVer + '/python-' + SemVer + '.exe',
      'https://www.python.org/ftp/python/' + SemVer + '/python-' + SemVer + '-amd64.exe'),
    '',
    False,
    False);
end;

procedure Dependency_AddBundledWinAcme;
begin
  if IsWinAcmeInstalled() = False then
  begin
    ExtractTemporaryFile('Win-acme-2.2.9.1701.msi');
    Dependency_Add(
      'Win-acme-2.2.9.1701.msi',
      '/quiet',
      'WinAcme v2.2.9.1701',
      '',
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddWinAcme;
begin
  if IsWinAcmeInstalled() = False then
  begin
    Dependency_Add(
      'Win-acme-2.2.9.1701.msi',
      '/quiet',
      'WinAcme v2.2.9.1701',
      Dependency_String(
      '',
      'https://github.com/ONLYOFFICE/win-acme-installer/releases/download/v2.2.9.1701/Win-acme-2.2.9.1701.msi'),
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddBundledOpenSSL;
begin
  if IsOpenSSLInstalled() = False then
  begin
    ExtractTemporaryFile('FireDaemon-OpenSSL-x64-3.3.0.exe');
    Dependency_Add(
      'FireDaemon-OpenSSL-x64-3.3.0.exe',
      '/exenoui /qn /norestart REBOOT=ReallySuppress ADJUSTSYSTEMPATHENV=yes',
      'OpenSSL x64 3.3.0',
      '',
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddOpenSSL;
begin
  if IsOpenSSLInstalled() = False then
  begin
    Dependency_Add(
      'openssl.exe',
      '/exenoui /qn /norestart REBOOT=ReallySuppress ADJUSTSYSTEMPATHENV=yes',
      'OpenSSL x64 3.3.0',
      Dependency_String(
        '',
        'https://download.onlyoffice.com/install/windows/redist/FireDaemon-OpenSSL-x64-3.3.0.exe'),
      '',
      False,
      False);
  end;
end;

[Setup]
