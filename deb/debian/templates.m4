Template: M4_ONLYOFFICE_VALUE/db-type
Type: select
Choices: postgres, mysql
Default: postgres
Description: Choose database type:

Template: M4_ONLYOFFICE_VALUE/db-host
Type: string
Default: localhost
Description: Database host:

Template: M4_ONLYOFFICE_VALUE/db-port
Type: string
Default: 5432
Description: Database port:

Template: M4_ONLYOFFICE_VALUE/db-user
Type: string
Default: M4_ONLYOFFICE_VALUE
Description: Database user:

Template: M4_ONLYOFFICE_VALUE/db-pwd
Type: password
Default: M4_ONLYOFFICE_VALUE
Description: Database password:

Template: M4_ONLYOFFICE_VALUE/db-name
Type: string
Default: M4_ONLYOFFICE_VALUE
Description: Database name:

Template: M4_ONLYOFFICE_VALUE/remove-db
Type: boolean
Default: false
Description: Remove database?
 This operation will remove the database which contain all ONLYOFFICE data. It is recommended to take backup before removing the database.

Template: M4_ONLYOFFICE_VALUE/cluster-mode
Type: boolean
Default: false
Description: Use cluster mode?
 Type true if M4_PRODUCT_NAME will use in cluster mode.

Template: M4_ONLYOFFICE_VALUE/ds-port
Type: string
Default: 80
Description: M4_PRODUCT_NAME listening port:

Template: M4_ONLYOFFICE_VALUE/docservice-port
Type: string
Default: 8000
Description: M4_PRODUCT_NAME docservice listening port:

Template: M4_ONLYOFFICE_VALUE/spellchecker-port
Type: string
Default: 8080
Description: M4_PRODUCT_NAME spellchecker listening port:

Template: M4_ONLYOFFICE_VALUE/example-port
Type: string
Default: 3000
Description: M4_PRODUCT_NAME example listening port:

Template: M4_ONLYOFFICE_VALUE/redis-host
Type: string
Default: localhost
Description: Redis host:

Template: M4_ONLYOFFICE_VALUE/rabbitmq-host
Type: string
Default: localhost
Description: RabbitMQ host:

Template: M4_ONLYOFFICE_VALUE/rabbitmq-user
Type: string
Default: guest
Description: RabbitMQ user:

Template: M4_ONLYOFFICE_VALUE/rabbitmq-pwd
Type: password
Default: guest
Description: RabbitMQ password:

Template: M4_ONLYOFFICE_VALUE/jwt-enabled
Type: boolean
Default: false
Description: Enable jwt for M4_PRODUCT_NAME?

Template: M4_ONLYOFFICE_VALUE/jwt-secret
Type: string
Default: secret
Description: Jwt secret:

Template: M4_ONLYOFFICE_VALUE/jwt-header
Type: string
Default: Authorization
Description: Jwt authorization header:
