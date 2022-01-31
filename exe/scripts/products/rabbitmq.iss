; http://support.microsoft.com/kb/239114

[CustomMessages]
rabbitmq_title=RabbitMQ 3.8.9 

rabbitmq_size=16.7 MB

[Code]
const
	rabbitmq_url = 'http://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.9/rabbitmq-server-3.8.9.exe';

procedure rabbitmq(minVersion: string);
begin
	if (FileExists(ExpandConstant('{pf64}{\}RabbitMQ Server{\}rabbitmq_server-3.8.9{\}sbin{\}rabbitmq-server.bat')) <> True ) then
		AddProduct('rabbitmq-server.exe',
			'',
			CustomMessage('rabbitmq_title'),
			CustomMessage('rabbitmq_size'),
			rabbitmq_url,
			false, false, false);
end;

[Setup]
