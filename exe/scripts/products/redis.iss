; http://support.microsoft.com/kb/239114

[CustomMessages]
redis_title=Redis

redis_size=6.5 MB

[Code]
const
	redis_url = 'http://download.onlyoffice.com/install/windows/redist/Redis-x64-3.0.504.msi';

procedure redis(minVersion: string);
begin
	if (FileExists(ExpandConstant('{pf64}{\}Redis{\}redis-server.exe')) <> True ) then
		AddProduct('redis.msi',
			'/qb',
			CustomMessage('redis_title'),
			CustomMessage('redis_size'),
			redis_url,
			true, false, false);
end;

[Setup]
