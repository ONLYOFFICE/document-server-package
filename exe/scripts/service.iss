[Code]

procedure Nssm(Command: String; SrvName: String; Param: String);
var
  ResultCode: Integer;
  NssmParam: String;
begin
  NssmParam := Command + ' ' + SrvName + ' ';

  if Param <> '' then
    NssmParam := NssmParam + ' ' + Param;

  Exec(
    ExpandConstant('{#NSSM}'),
    NssmParam,
    '', 
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode);

  Log('Run nssm ' + NssmParam + 'Returned code ' + IntToStr(ResultCode));
end;

procedure InstallSrv(SrvName: String; SrvExec: String; SrvDscr: String; RunDir: String; Env: String; StdOut: String; StdErr: String);

begin
  Nssm('install', SrvName, SrvExec);
  if SrvDscr <> '' then
    Nssm('set', SrvName, 'Description ' + SrvDscr);

  if RunDir <> '' then
    Nssm('set', SrvName, 'AppDirectory ' + RunDir);

  if Env <> '' then
    Nssm('set', SrvName, 'AppEnvironmentExtra ' + Env);

  if StdOut <> '' then
    Nssm('set', SrvName, 'AppStdout ' + StdOut);

  if StdErr <> '' then
    Nssm('set', SrvName, 'AppStderr ' + StdErr);
end;

procedure StopSrv(SrvName: String);

var ResultCode: Integer;
begin
  Exec(
    'sc',
    'stop ' + SrvName,
    '', 
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode);
  
  Log('Stop service ' + SrvName + 'Returned code ' + IntToStr(ResultCode));
end;

procedure RemoveSrv(SrvName: String);

begin
  StopSrv(SrvName);
  Nssm('remove', SrvName, 'confirm');
end;

