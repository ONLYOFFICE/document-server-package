; http://support.microsoft.com/kb/239114

[CustomMessages]
nodejs10x_title=Node.js

nodejs10x_size=17.4 MB

[Code]
const
  nodejs10x_url = 'http://nodejs.org/dist/v10.17.0/node-v10.17.0-x64.msi';

procedure nodejs10x(minVersion: string);
begin
	//check for node 10.x installation
	if (compareversion(fileversion(ExpandConstant('{pf64}{\}nodejs{\}node.exe')), minVersion) < 0) then
		AddProduct('nodejs10x.msi',
			'/qb',
			CustomMessage('nodejs10x_title'),
			CustomMessage('nodejs10x_size'),
			nodejs10x_url,
			false, false, false);
end;

[Setup]
