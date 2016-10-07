; http://support.microsoft.com/kb/239114

[CustomMessages]
rabbitmq_title=RabbitMQ

en.rabbitmq_size=5.3 MB
; de.rabbitmq_size=5,3 MB

[Code]
const
	rabbitmq_url = 'http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.5/rabbitmq-server-3.6.5.exe';

procedure rabbitmq(minVersion: string);
begin
	//check for postgresql binaries
	if (FileExists(ExpandConstant('{pf64}{\}RabbitMQ Server{\}rabbitmq_server-3.6.5{\}sbin{\}rabbitmq-server.bat')) <> True ) then
		AddProduct('rabbitmq-server.exe',
			'',
			CustomMessage('rabbitmq_title'),
			CustomMessage('rabbitmq_size'),
			rabbitmq_url,
			false, false, false);
end;

[Setup]
