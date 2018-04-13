; http://support.microsoft.com/kb/239114

[CustomMessages]
nodejs6x_title=Node.js

nodejs6x_size=12.4 MB

[Code]
const
	nodejs6x_url = 'http://nodejs.org/dist/v6.11.3/node-v6.11.3-x64.msi';

procedure nodejs6x(minVersion: string);
begin
	//check for node 6.x installation
	if (compareversion(fileversion(ExpandConstant('{pf64}{\}nodejs{\}node.exe')), minVersion) < 0) then
		AddProduct('nodejs6x.msi',
			'/qb',
			CustomMessage('nodejs6x_title'),
			CustomMessage('nodejs6x_size'),
			nodejs6x_url,
			false, false, false);
end;

[Setup]
