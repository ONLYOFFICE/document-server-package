# -*- coding: utf-8 -*-

import logging
from sys import argv
from uuid import uuid4


def check_rabbitmq(protocol, username, password, host):
    import pika
    from pika.exchange_type import ExchangeType

    logging.basicConfig(level=logging.DEBUG)

    parameters = pika.URLParameters(
        f"{protocol}://{username}:{password}@{host}"
    )
    connection = pika.BlockingConnection(parameters)
    channel = connection.channel()

    channel.exchange_declare(
        exchange="test_exchange",
        exchange_type=ExchangeType.direct,
        passive=False,
        durable=True,
        auto_delete=False,
    )

    channel.queue_declare(queue="standard_queue", durable=True)
    channel.queue_bind(
        exchange="test_exchange",
        queue="standard_queue",
        routing_key="standard_key",
    )

    channel.queue_declare(queue="group_queue", durable=True)
    channel.queue_bind(
        exchange="test_exchange",
        queue="group_queue",
        routing_key="group_key",
    )

    for routing_key, body in (
        ("standard_key", "queue:group"),
        ("group_key", "Message to group_key"),
        ("standard_key", "Message to standard_key"),
    ):
        channel.basic_publish(
            exchange="test_exchange",
            routing_key=routing_key,
            body=body,
            properties=pika.BasicProperties(content_type="text/plain"),
        )
        connection.process_data_events()

    connection.close()


def check_redis(host):
    from redis import Redis

    client = Redis(
        host=host,
        port=6379,
        socket_connect_timeout=5,
        socket_timeout=5,
        decode_responses=True,
    )

    key = f"onlyoffice:installer:connection-test:{uuid4().hex}"
    value = uuid4().hex
    key_created = False

    try:
        if client.ping() is not True:
            raise RuntimeError("Redis PING failed")

        if client.set(key, value, ex=60) is not True:
            raise RuntimeError("Redis SET failed")
        key_created = True

        if client.get(key) != value:
            raise RuntimeError("Redis GET returned an unexpected value")
    finally:
        if key_created:
            client.delete(key)
        client.close()


_, service, *arguments = argv

if service == "rabbitmq":
    check_rabbitmq(*arguments)
elif service == "redis":
    check_redis(*arguments)
else:
    raise ValueError(f"Unsupported service: {service}")
