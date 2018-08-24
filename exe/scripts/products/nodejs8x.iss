; http://support.microsoft.com/kb/239114

[CustomMessages]
nodejs8x_title=Node.js

nodejs8x_size=15.8 MB

[Code]
const
  nodejs8x_url = 'http://nodejs.org/dist/v8.11.4/node-v8.11.4-x64.msi';

procedure nodejs8x(minVersion: string);
begin
	//check for node 8.x installation
	if (compareversion(fileversion(ExpandConstant('{pf64}{\}nodejs{\}node.exe')), minVersion) < 0) then
		AddProduct('nodejs8x.msi',
			'/qb',
			CustomMessage('nodejs8x_title'),
			CustomMessage('nodejs8x_size'),
			nodejs8x_url,
			false, false, false);
end;

[Setup]
