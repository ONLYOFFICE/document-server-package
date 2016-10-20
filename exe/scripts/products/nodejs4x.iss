; http://support.microsoft.com/kb/239114

[CustomMessages]
nodejs4x_title=Node.js

en.nodejs4x_size=10.5 MB
; de.nodejs4x_size=10,5 MB

[Code]
const
	nodejs4x_url = 'http://nodejs.org/dist/v4.6.1/node-v4.6.1-x86.msi';

procedure nodejs4x(minVersion: string);
begin
	//check for node 4.x installation
	if (compareversion(fileversion(ExpandConstant('{pf32}{\}nodejs{\}node.exe')), minVersion) < 0) then
		AddProduct('nodejs4x.msi',
			'/qb',
			CustomMessage('nodejs4x_title'),
			CustomMessage('nodejs4x_size'),
			nodejs4x_url,
			false, false, false);
end;

[Setup]
