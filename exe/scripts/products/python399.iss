; requires Windows 10, Windows 7 Service Pack 1, Windows 8, Windows 8.1
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

	python399_upgradecode = '{B0D35164-DCE0-5CD6-B3AE-55F0AE08E42E}';
	python399_upgradecode_x64 = '{0D8FFA35-4E68-56AE-9C6D-7B33F2B22892}';

procedure python399(minVersion: string);
begin
	if (not IsIA64()) then begin
		if (not msiproductupgrade(GetString(python399_upgradecode, python399_upgradecode_x64, ''), minVersion)) then
			AddProduct('python 3.9.9' + GetArchitectureString() + '.exe',
				'PrependPath=1 DefaultJustForMeTargetDir=' + ExpandConstant('{sd}') + '\Python  /passive /norestart , ',
				CustomMessage('python399_title' + GetArchitectureString()),
				CustomMessage('python399_size' + GetArchitectureString()),
				GetString(python399_url, python399_url_x64, ''),
				false, false, false);
	end;
end;

[Setup]
