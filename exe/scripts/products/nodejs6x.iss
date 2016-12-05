; http://support.microsoft.com/kb/239114

[CustomMessages]
nodejs6x_title=Node.js

en.nodejs6x_size=10.9 MB
; de.nodejs6x_size=10,9 MB

[Code]
const
	nodejs6x_url = 'http://nodejs.org/dist/v6.9.1/node-v6.9.1-x86.msi';

procedure nodejs6x(minVersion: string);
begin
	//check for node 6.x installation
	if (compareversion(fileversion(ExpandConstant('{pf32}{\}nodejs{\}node.exe')), minVersion) < 0) then
		AddProduct('nodejs6x.msi',
			'/qb',
			CustomMessage('nodejs6x_title'),
			CustomMessage('nodejs6x_size'),
			nodejs6x_url,
			false, false, false);
end;

[Setup]
