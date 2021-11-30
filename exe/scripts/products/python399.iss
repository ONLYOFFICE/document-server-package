; requires Windows 10, Windows 7 Service Pack 1, Windows 8, Windows 8.1, Windows Server 2003 Service Pack 2, Windows Server 2008 R2 SP1, Windows Server 2008 Service Pack 2, Windows Server 2012, Windows Vista Service Pack 2, Windows XP Service Pack 3
; https://www.python.org/downloads/

[CustomMessages]
python399_title=Python 3.9.9 
python399_title_x64=Python 3.9.9 64-Bit 

python399_size=26 MB
python399_size_x64=27 MB

[Code]
const
	python399_url = 'http://www.python.org/ftp/python/3.9.9/python-3.9.9.exe';
	python399_url_x64 = 'http://www.python.org/ftp/python/3.9.9/python-3.9.9-amd64.exe';

	python399_upgradecode = '{B50BC36B-3C19-491C-9CF8-BC5C384D70F2}';
	python399_upgradecode_x64 = '{5B4B8687-6FD2-4002-A109-CC428BC53026}';

procedure python399(minVersion: string);
begin
	if (not IsIA64()) then begin
		if (not msiproductupgrade(GetString(python399_upgradecode, python399_upgradecode_x64, ''), minVersion)) then
			AddProduct('python 3.9.9' + GetArchitectureString() + '.exe',
				'/passive /norestart',
				CustomMessage('python399_title' + GetArchitectureString()),
				CustomMessage('python399_size' + GetArchitectureString()),
				GetString(python399_url, python399_url_x64, ''),
				false, false, false);
	end;
end;

[Setup]
