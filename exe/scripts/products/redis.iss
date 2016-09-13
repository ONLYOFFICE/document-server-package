; http://support.microsoft.com/kb/239114

[CustomMessages]
redis_title=PostgreSQL

en.redis_size=5.9 MB
; de.redis_size=5,9 MB

[Code]
const
	redis_url = 'http://github.com/MSOpenTech/redis/releases/download/win-3.2.100/Redis-x64-3.2.100.msi';

procedure redis(minVersion: string);
begin
	//check for postgresql binaries
	if (FileExists(ExpandConstant('{pf64}{\}Redis{\}redis-server.exe')) <> True ) then
		AddProduct('redis.msi',
			'/qb',
			CustomMessage('redis_title'),
			CustomMessage('redis_size'),
			redis_url,
			false, false, false);
end;

[Setup]
