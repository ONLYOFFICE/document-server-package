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

function IsCertbotInstalled(): Boolean;
begin
  Result := IsInstalled('Certbot$', '{#Registry32}') or IsInstalled('Certbot$', '{#Registry64}');
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
  Version := '5';
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

procedure Dependency_AddErlang;
begin
  if IsErlangInstalled() = False then
  begin
    Dependency_Add(
      'erlang.exe',
      '/S',
      'Erlang 26.2.1 x64',
      Dependency_String(
        '',
        'https://github.com/erlang/otp/releases/download/OTP-26.2.1/otp_win64_26.2.1.exe'),
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
      'rabbitmq-server.exe',
      '/S',
      'RabbitMQ 3.12.11',
      Dependency_String(
        '',
        'https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.12.11/rabbitmq-server-3.12.11.exe'),
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
      'PostgreSQL 12.17 x64',
      Dependency_String(
        '',
        'https://get.enterprisedb.com/postgresql/postgresql-12.17-1-windows-x64.exe'),
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddRedis;
var
  Version: String;
begin
  Version := '5.0.10';
  Dependency_Add(
    'redis.msi',
    '/quiet',
    'Redis ' + Version + 'x64',
    Dependency_String(
      '',
      'https://download.onlyoffice.com/install/windows/redist/Redis-x64-5.0.10.msi'),
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

procedure Dependency_AddCertbot;
begin
  if IsCertbotInstalled() = False then
  begin
    Dependency_Add(
      'certbot.exe',
      '/S',
      'Certbot v2.6.0',
      Dependency_String(
        '',
        'https://github.com/certbot/certbot/releases/download/v2.6.0/certbot-beta-installer-win_amd64_signed.exe'),
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
        'https://download.firedaemon.com/FireDaemon-OpenSSL/FireDaemon-OpenSSL-x64-3.3.0.exe'),
      '',
      False,
      False);
  end;
end;

[Setup]
