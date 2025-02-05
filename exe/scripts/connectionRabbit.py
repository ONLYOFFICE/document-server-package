# -*- coding: utf-8 -*-
# pylint: disable=C0111,C0103,R0205

import logging
import pika
from pika.exchange_type import ExchangeType
from sys import argv

script, protocol, username, password, host = argv

logging.basicConfig(level=logging.DEBUG)

url = f"{protocol}://{username}:{password}@{host}"
parameters = pika.URLParameters(url)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()
channel.exchange_declare(exchange="test_exchange",
                         exchange_type=ExchangeType.direct,
                         passive=False,
                         durable=True,
                         auto_delete=False)

channel.queue_declare(queue='standard_queue', durable=True)
channel.queue_bind(exchange='test_exchange', queue='standard_queue', routing_key='standard_key')

channel.queue_declare(queue='group_queue', durable=True)
channel.queue_bind(exchange='test_exchange', queue='group_queue', routing_key='group_key')

print("Sending message to create a queue")
channel.basic_publish(
    exchange='test_exchange',
    routing_key='standard_key',
    body='queue:group',
    properties=pika.BasicProperties(content_type='text/plain')
)

connection.process_data_events()

print("Sending text message to group")
channel.basic_publish(
    exchange='test_exchange',
    routing_key='group_key',
    body='Message to group_key',
    properties=pika.BasicProperties(content_type='text/plain')
)

connection.process_data_events()

print("Sending text message")
channel.basic_publish(
    exchange='test_exchange',
    routing_key='standard_key',
    body='Message to standard_key',
    properties=pika.BasicProperties(content_type='text/plain')
)

connection.process_data_events()
connection.close()
