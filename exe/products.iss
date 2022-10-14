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
  Result := IsInstalled('Certbot$', '{#Registry32}');
end;

procedure Dependency_AddErlang;
begin
  if IsErlangInstalled() = False then
  begin
    Dependency_Add(
      'erlang.exe',
      '',
      'Erlang 23 x64',
      Dependency_String(
        '',
        'https://erlang.org/download/otp_win64_23.1.exe'),
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
      '',
      'RabbitMQ 3.8',
      Dependency_String(
        '',
        'https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.9/rabbitmq-server-3.8.9.exe'),
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddPostgreSQL;
var
  ResultCode: Integer;
begin
  if IsPostgreSQLInstalled() = False then
  begin
    Dependency_Add(
      'postgresql.exe',
      '--unattendedmodeui minimal',
      'PostgreSQL 9.5 x64',
      Dependency_String(
        '',
        'https://sbp.enterprisedb.com/getfile.jsp?fileid=1258024'),
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddRedis;
var
  Version: String;
begin
  Version := '3';
  if not IsMsiProductInstalled(
           Dependency_String(
            '',
            '{05410198-7212-4FC4-B7C8-AFEFC3DA0FBC}'),
            StrToInt(Version)) then
  begin
    Dependency_Add(
      'redis.msi',
      '/qb',
      'Redis ' + Version + 'x64',
      Dependency_String(
        '',
        'https://download.onlyoffice.com/install/windows/redist/Redis-x64-3.0.504.msi'),
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddPython3;
var
  Version: String;
  Patch: String;
  SemVer: String;
begin
  Version := '3.7';
  Patch := '2';
  SemVer := Version + '.' + Patch;
  if not IsMsiProductInstalled(
           Dependency_String(
            '{A6516328-639D-562B-8A85-C3E305DDAC6F}',
            '{39BBB1D2-2CD1-57A7-A873-E06D44986C30}'),
            StrToInt(Version)) then 
  begin
    Dependency_Add(
      'python ' + Version + Dependency_ArchSuffix + '.exe',
      'PrependPath=1 DefaultJustForMeTargetDir=' +
        ExpandConstant('{sd}') + '\Python  /passive /norestart',
      'Python ' + Version + Dependency_ArchTitle,
      Dependency_String(
        'https://www.python.org/ftp/python/' + SemVer + '/python-' + SemVer + '.exe',
        'https://www.python.org/ftp/python/' + SemVer + '/python-' + SemVer + '-amd64.exe'),
      '',
      False,
      False);
  end;
end;

procedure Dependency_AddCertbot;
begin
  if IsCertbotInstalled() = False then
  begin
    Dependency_Add(
      'certbot.exe',
      '/S',
      'Certbot beta win32',
      Dependency_String(
        '',
        'https://dl.eff.org/certbot-beta-installer-win32.exe'),
      '',
      False,
      False);
  end;
end;

[Setup]
