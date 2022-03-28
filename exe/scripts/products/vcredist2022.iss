; requires Windows 10, Windows 7 Service Pack 1, Windows 8, Windows 8.1, Windows Server 2003 Service Pack 2, Windows Server 2008 R2 SP1, Windows Server 2008 Service Pack 2, Windows Server 2012, Windows Vista Service Pack 2, Windows XP Service Pack 3
; http://www.visualstudio.com/en-us/downloads/

[CustomMessages]
vcredist2022_title=Visual C++ 2022 Redistributable
vcredist2022_title_x64=Visual C++ 2022 64-Bit Redistributable

vcredist2022_size=13.1 MB
vcredist2022_size_x64=24.1 MB

[Code]
const
	vcredist2022_url = 'http://aka.ms/vs/17/release/vc_redist.x86.exe';
	vcredist2022_url_x64 = 'http://aka.ms/vs/17/release/vc_redist.x64.exe';

	vcredist2022_upgradecode = '{5720EC03-F26F-40B7-980C-50B5D420B5DE}';
	vcredist2022_upgradecode_x64 = '{A181A302-3F6D-4BAD-97A8-A426A6499D78}';

procedure vcredist2022(minVersion: string);
begin
	if (not IsIA64()) then begin
		if (not msiproductupgrade(GetString(vcredist2022_upgradecode, vcredist2022_upgradecode_x64, ''), minVersion)) then
			AddProduct('vcredist2022' + GetArchitectureString() + '.exe',
				'/passive /norestart',
				CustomMessage('vcredist2022_title' + GetArchitectureString()),
				CustomMessage('vcredist2022_size' + GetArchitectureString()),
				GetString(vcredist2022_url, vcredist2022_url_x64, ''),
				false, false, false);
	end;
end;

[Setup]
