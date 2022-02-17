# keystone

## Parameters

### Global parameters

| Name                      | Form title | Description                                     | Value |
| ------------------------- | ---------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    |            | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` |            | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     |            | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                                                | Form title     | Description                                                                | Value                             |
| --------------------------------------------------- | -------------- | -------------------------------------------------------------------------- | --------------------------------- |
| `replicaCount`                                      |                | Number of keystone replicas to deploy (requires ReadWriteMany PVC support) | `1`                               |
| `existingSecret`                                    | openstack 密钥名称 | Name of existing secret containing keystone credentials                    | `openstack-password`              |
| `serviceAccountName`                                |                | ServiceAccount name                                                        | `keystone`                        |
| `resources.limits`                                  |                | The resources limits for the Controller container                          | `{}`                              |
| `resources.requests`                                |                | The requested resources for the Controller container                       | `{}`                              |
| `podSecurityContext.enabled`                        |                | Enabled keystone pods' Security Context                                    | `true`                            |
| `podSecurityContext.fsGroup`                        |                | Set keystone pod's Security Context fsGroup                                | `42424`                           |
| `podSecurityContext.runAsUser`                      |                | Set keystone container's Security Context runAsUser                        | `42424`                           |
| `containerSecurityContext.enabled`                  |                | Enabled keystone containers' Security Context                              | `true`                            |
| `containerSecurityContext.runAsGroup`               |                | Group ID for the container                                                 | `42424`                           |
| `containerSecurityContext.allowPrivilegeEscalation` |                | Switch privilegeEscalation possibility on or off                           | `false`                           |
| `containerSecurityContext.readOnlyRootFilesystem`   |                | mount / (root) as a readonly filesystem                                    | `true`                            |
| `livenessProbe.enabled`                             |                | Enable livenessProbe                                                       | `true`                            |
| `livenessProbe.httpGet.path`                        |                | Request path for livenessProbe                                             | `/v3/`                            |
| `livenessProbe.httpGet.port`                        |                | Port for livenessProbe                                                     | `5000`                            |
| `livenessProbe.httpGet.scheme`                      |                | Scheme for livenessProbe                                                   | `HTTP`                            |
| `livenessProbe.initialDelaySeconds`                 |                | Initial delay seconds for livenessProbe                                    | `50`                              |
| `livenessProbe.periodSeconds`                       |                | Period seconds for livenessProbe                                           | `60`                              |
| `livenessProbe.timeoutSeconds`                      |                | Timeout seconds for livenessProbe                                          | `15`                              |
| `livenessProbe.failureThreshold`                    |                | Failure threshold for livenessProbe                                        | `3`                               |
| `livenessProbe.successThreshold`                    |                | Success threshold for livenessProbe                                        | `1`                               |
| `readinessProbe.enabled`                            |                | Enable readinessProbe                                                      | `true`                            |
| `readinessProbe.httpGet.path`                       |                | Request path for readinessProbe                                            | `/v3/`                            |
| `readinessProbe.httpGet.port`                       |                | Port for readinessProbe                                                    | `5000`                            |
| `readinessProbe.httpGet.scheme`                     |                | Scheme for readinessProbe                                                  | `HTTP`                            |
| `readinessProbe.initialDelaySeconds`                |                | Initial delay seconds for readinessProbe                                   | `50`                              |
| `readinessProbe.periodSeconds`                      |                | Period seconds for readinessProbe                                          | `60`                              |
| `readinessProbe.timeoutSeconds`                     |                | Timeout seconds for readinessProbe                                         | `15`                              |
| `readinessProbe.failureThreshold`                   |                | Failure threshold for readinessProbe                                       | `3`                               |
| `readinessProbe.successThreshold`                   |                | Success threshold for readinessProbe                                       | `1`                               |
| `customLivenessProbe`                               |                | Override default liveness probe                                            | `{}`                              |
| `customReadinessProbe`                              |                | Override default readiness probe                                           | `{}`                              |
| `lifecycle.preStop.exec.command`                    |                | LifecycleHooks to set additional configuration at startup                  | `["/tmp/keystone-api.sh","stop"]` |


### Keystone Image parameters

| Name                                | Form title | Description                                       | Value                             |
| ----------------------------------- | ---------- | ------------------------------------------------- | --------------------------------- |
| `image.keystoneImage.registry`      |            | Moodle image registry                             | `docker.io`                       |
| `image.keystoneImage.repository`    |            | Moodle image repository                           | `openstackhelm/keystone`          |
| `image.keystoneImage.tag`           |            | Moodle image tag (immutable tags are recommended) | `wallaby-ubuntu_focal`            |
| `image.keystoneImage.pullPolicy`    |            | Moodle image pull policy                          | `IfNotPresent`                    |
| `image.keystoneImage.pullSecrets`   |            | Specify docker-registry secret names as an array  | `[]`                              |
| `image.entrypointImage.registry`    |            | Moodle image registry                             | `quay.io`                         |
| `image.entrypointImage.repository`  |            | Moodle image repository                           | `airshipit/kubernetes-entrypoint` |
| `image.entrypointImage.tag`         |            | Moodle image tag (immutable tags are recommended) | `v1.0.0`                          |
| `image.entrypointImage.pullPolicy`  |            | Moodle image pull policy                          | `IfNotPresent`                    |
| `image.entrypointImage.pullSecrets` |            | Specify docker-registry secret names as an array  | `[]`                              |
| `image.heatImage.registry`          |            | Moodle image registry                             | `docker.io`                       |
| `image.heatImage.repository`        |            | Moodle image repository                           | `openstackhelm/heat`              |
| `image.heatImage.tag`               |            | Moodle image tag (immutable tags are recommended) | `wallaby-ubuntu_focal`            |
| `image.heatImage.pullPolicy`        |            | Moodle image pull policy                          | `IfNotPresent`                    |
| `image.heatImage.pullSecrets`       |            | Specify docker-registry secret names as an array  | `[]`                              |


### Traffic Exposure Parameters

| Name                                | Form title | Description                                                                   | Value                    |
| ----------------------------------- | ---------- | ----------------------------------------------------------------------------- | ------------------------ |
| `service.type`                      |            | Kubernetes Service type                                                       | `ClusterIP`              |
| `service.publicService.name`        |            | keystone public svc name                                                      | `keystone-api`           |
| `service.publicService.port`        |            | keystone public svc port                                                      | `5000`                   |
| `service.publicService.portname`    |            | keystone public svc port name                                                 | `ks-pub`                 |
| `service.internalService.name`      |            | keystone internal svc name                                                    | `keystone`               |
| `service.internalService.httpPort`  |            | keystone internal svc http port                                               | `80`                     |
| `service.internalService.httpName`  |            | keystone internal svc http port name                                          | `http`                   |
| `service.internalService.httpsPort` |            | keystone internal svc https port                                              | `443`                    |
| `service.internalService.httpsName` |            | keystone internal svc https port name                                         | `https`                  |
| `service.nodePorts.http`            |            | Node port for HTTP                                                            | `""`                     |
| `service.nodePorts.https`           |            | Node port for HTTPS                                                           | `""`                     |
| `service.clusterIP`                 |            | Cluster internal IP of the service                                            | `""`                     |
| `service.loadBalancerIP`            |            | keystone service Load Balancer IP                                             | `""`                     |
| `service.externalTrafficPolicy`     |            | keystone service external traffic policy                                      | `Cluster`                |
| `ingress.enabled`                   |            | Enable ingress record generation for keystone                                 | `true`                   |
| `ingress.pathType`                  |            | Ingress path type                                                             | `ImplementationSpecific` |
| `ingress.apiVersion`                |            | Force Ingress API version (automatically detected if not set)                 | `""`                     |
| `ingress.ingressClassName`          |            | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+) | `nginx`                  |
| `ingress.hostname`                  |            | Default host for the ingress record                                           | `keystone`               |
| `ingress.path`                      |            | Default path for the ingress record                                           | `/`                      |


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
| `externalDatabase.user`                    |            | External Database username                                                | `keystone`           |
| `externalDatabase.password`                |            | External Database user password                                           | `""`                 |
| `externalDatabase.database`                |            | External Database database name                                           | `keystone`           |
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
| `nginx-ingress-controller.service.type`          |            | controller service type                                                          | `ClusterIP`   |
| `nginx-ingress-controller.podLabels.app`         |            | for nginx-ingress-controller pod add labels to be compatible with keystone SVC   | `ingress-api` |
| `nginx-ingress-controller.kind`                  |            | Install as DaemonSet                                                             | `DaemonSet`   |
| `nginx-ingress-controller.daemonset.useHostPort` |            | If `kind` is `DaemonSet`, this will enable `hostPort` for `TCP/80` and `TCP/443` | `true`        |
