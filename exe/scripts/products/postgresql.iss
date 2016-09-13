; http://support.microsoft.com/kb/239114

[CustomMessages]
postgresql_title=PostgreSQL

en.postgresql_size=62.0 MB
; de.postgresql_size=62,0 MB

[Code]
const
	postgresql_url = 'http://get.enterprisedb.com/postgresql/postgresql-9.5.4-1-windows-x64.exe';

procedure postgresql(minVersion: string);
begin
	//check for postgresql binaries
	if (compareversion(fileversion(ExpandConstant('{pf64}{\}postgresql{\}9.5{\}bin{\}postgres.exe')), minVersion) < 0) then
		AddProduct('postgresql.exe',
			'--unattendedmodeui minimal',
			CustomMessage('postgresql_title'),
			CustomMessage('postgresql_size'),
			postgresql_url,
			false, false, false);
end;

[Setup]
