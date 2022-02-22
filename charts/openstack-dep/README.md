# openstack-dep

## Parameters


### Global parameters

| Name                      | Form title | Description                                     | Value |
| ------------------------- | ---------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    |            | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` |            | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     |            | Global StorageClass for Persistent Volume(s)    | `""`  |


### Database Parameters

| Name                                       | Form title | Description                                                               | Value                |
| ------------------------------------------ | ---------- | ------------------------------------------------------------------------- | -------------------- |
| `mariadb.enabled`                          |            | Deploy a MariaDB server to satisfy the applications database requirements | `true`               |
| `mariadb.architecture`                     |            | MariaDB architecture. Allowed values: `standalone` or `replication`       | `standalone`         |
| `mariadb.auth.existingSecret`              |            | Use existing secret for password details                                  | `openstack-password` |
| `mariadb.primary.persistence.enabled`      |            | Enable persistence on MariaDB using PVC(s)                                | `true`               |
| `mariadb.primary.persistence.storageClass` |            | Persistent Volume storage class                                           | `""`                 |
| `mariadb.primary.persistence.accessModes`  |            | [array] Persistent Volume access modes                                    | `["ReadWriteOnce"]`  |
| `mariadb.primary.persistence.size`         |            | Persistent Volume size                                                    | `8Gi`                |
| `externalDatabase.host`                    |            | External Database server host                                             | `localhost`          |
| `externalDatabase.port`                    |            | External Database server port                                             | `3306`               |
| `externalDatabase.user`                    |            | External Database username                                                | `""`                 |
| `externalDatabase.password`                |            | External Database user password                                           | `""`                 |
| `externalDatabase.database`                |            | External Database database name                                           | `""`                 |
| `externalDatabase.existingSecret`          |            | The name of an existing secret with database credentials                  | `""`                 |


### RabbitMQ chart parameters

| Name                                      | Form title | Description                                                                     | Value                |
| ----------------------------------------- | ---------- | ------------------------------------------------------------------------------- | -------------------- |
| `rabbitmq.enabled`                        |            | Enable/disable RabbitMQ chart installation                                      | `true`               |
| `rabbitmq.auth.username`                  |            | RabbitMQ username                                                               | `openstack`          |
| `rabbitmq.auth.existingPasswordSecret`    |            | RabbitMQ password                                                               | `openstack-password` |
| `rabbitmq.persistence.enabled`            |            | Enable persistence on Rabbitmq using PVC(s)                                     | `true`               |
| `rabbitmq.persistence.storageClass`       |            | Persistent Volume storage class                                                 | `""`                 |
| `rabbitmq.persistence.accessModes`        |            | Persistent Volume access modes                                                  | `[]`                 |
| `rabbitmq.persistence.size`               |            | Persistent Volume size                                                          | `8Gi`                |
| `externalRabbitmq.enabled`                |            | Enable/disable external RabbitMQ                                                | `false`              |
| `externalRabbitmq.host`                   |            | Host of the external RabbitMQ                                                   | `localhost`          |
| `externalRabbitmq.port`                   |            | External RabbitMQ port number                                                   | `5672`               |
| `externalRabbitmq.username`               |            | External RabbitMQ username                                                      | `guest`              |
| `externalRabbitmq.password`               |            | External RabbitMQ password. It will be saved in a kubernetes secret             | `guest`              |
| `externalRabbitmq.vhost`                  |            | External RabbitMQ virtual host. It will be saved in a kubernetes secret         | `""`                 |
| `externalRabbitmq.existingPasswordSecret` |            | Existing secret with RabbitMQ password. It will be saved in a kubernetes secret | `""`                 |


### Memcached chart parameters

| Name                     | Form title | Description                                            | Value       |
| ------------------------ | ---------- | ------------------------------------------------------ | ----------- |
| `memcached.enabled`      |            | Deploy a Memcached server for caching database queries | `true`      |
| `memcached.service.port` |            | Memcached service port                                 | `11211`     |
| `externalCache.host`     |            | External cache server host                             | `localhost` |
| `externalCache.port`     |            | External cache server port                             | `11211`     |


### nginx-ingress-controller chart parameters

| Name                                             | Form title | Description                                                                      | Value         |
| ------------------------------------------------ | ---------- | -------------------------------------------------------------------------------- | ------------- |
| `nginx-ingress-controller.enabled`               |            | Deploy a ingress controller server                                               | `true`        |
| `nginx-ingress-controller.service.type`          |            | controller service type                                                          | `ClusterIP`   |
| `nginx-ingress-controller.podLabels.app`         |            | for nginx-ingress-controller pod add labels to be compatible with SVC            | `ingress-api` |
| `nginx-ingress-controller.kind`                  |            | Install as DaemonSet                                                             | `DaemonSet`   |
| `nginx-ingress-controller.daemonset.useHostPort` |            | If `kind` is `DaemonSet`, this will enable `hostPort` for `TCP/80` and `TCP/443` | `true`        |