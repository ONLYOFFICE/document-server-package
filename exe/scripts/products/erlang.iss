; http://support.microsoft.com/kb/239114

[CustomMessages]
erlang_title=Erlang

erlang_size=90.3 MB

[Code]
const
	erlang_url = 'http://erlang.org/download/otp_win64_23.1.exe';

procedure erlang(minVersion: string);
begin
	if (FileExists(ExpandConstant('{pf64}{\}erlang{\}erlang.exe')) <> True ) then
		AddProduct('erlang.exe',
			'',
			CustomMessage('erlang_title'),
			CustomMessage('erlang_size'),
			erlang_url,
			false, false, false);
end;

[Setup]
