# Cinder Charts

cinder charts 用来安装 openstack cinder 服务。该 charts 对接的 cinder 后端存储为 lvm。该charts 会自动创建一个 loop 设备，用来创建 cinder lvm 所用的逻辑卷.

## Parameters

### Global parameters

| Name                      | Form title | Description                                     | Value |
| ------------------------- | ---------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    |            | Global Docker registry secret names as an array | `""`  |
| `global.imagePullSecrets` |            | Global Docker image pullPolicy                  | `[]`  |
| `global.storageClass`     |            | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                                                   | Form title     | Description                                                              | Value                |
| ------------------------------------------------------ | -------------- | ------------------------------------------------------------------------ | -------------------- |
| `replicaCount`                                         |                | Number of cinder replicas to deploy (requires ReadWriteMany PVC support) | `1`                  |
| `existingSecret`                                       | openstack 密钥名称 | Name of existing secret containing cinder credentials                    | `openstack-password` |
| `serviceAccountName`                                   |                | ServiceAccount name                                                      | `cinder`             |
| `resources.limits`                                     |                | The resources limits for the Controller container                        | `{}`                 |
| `resources.requests`                                   |                | The requested resources for the Controller container                     | `{}`                 |
| `podSecurityContext.enabled`                           |                | Enabled cinder pods' Security Context                                    | `true`               |
| `podSecurityContext.runAsUser`                         |                | Set cinder pods' Security Context runAsUser                              | `0`                  |
| `containerSecurityContext.enabled`                     |                | Enabled cinder containers' Security Context                              | `true`               |
| `containerSecurityContext.runAsUser`                   |                | Set cinder containers' Security Context runAsUser                        | `0`                  |
| `lvmcontainerSecurityContext.enabled`                  |                | Enabled cinder lvm containers' Security Context                          | `true`               |
| `lvmcontainerSecurityContext.privileged`               |                | Switch cinder lvm containers' privilege possibility on or off            | `true`               |
| `lvmcontainerSecurityContext.runAsUser`                |                | Set cinder lvm containers' Security Context runAsUser                    | `0`                  |
| `lvmcontainerSecurityContext.allowPrivilegeEscalation` |                | Switch cinder lvm containers' privilegeEscalation possibility on or off  | `true`               |
| `livenessProbe.enabled`                                |                | Enable livenessProbe                                                     | `true`               |
| `livenessProbe.tcpSocket.port`                         |                | Port for livenessProbe                                                   | `8776`               |
| `livenessProbe.initialDelaySeconds`                    |                | Initial delay seconds for livenessProbe                                  | `30`                 |
| `livenessProbe.periodSeconds`                          |                | Period seconds for livenessProbe                                         | `10`                 |
| `livenessProbe.timeoutSeconds`                         |                | Timeout seconds for livenessProbe                                        | `1`                  |
| `livenessProbe.failureThreshold`                       |                | Failure threshold for livenessProbe                                      | `3`                  |
| `livenessProbe.successThreshold`                       |                | Success threshold for livenessProbe                                      | `1`                  |
| `readinessProbe.enabled`                               |                | Enable readinessProbe                                                    | `true`               |
| `readinessProbe.tcpSocket.port`                        |                | Port for readinessProbe                                                  | `8776`               |
| `readinessProbe.periodSeconds`                         |                | Period seconds for readinessProbe                                        | `10`                 |
| `readinessProbe.timeoutSeconds`                        |                | Timeout seconds for readinessProbe                                       | `1`                  |
| `readinessProbe.failureThreshold`                      |                | Failure threshold for readinessProbe                                     | `3`                  |
| `readinessProbe.successThreshold`                      |                | Success threshold for readinessProbe                                     | `1`                  |
| `customLivenessProbe`                                  |                | Override default liveness probe                                          | `{}`                 |
| `customReadinessProbe`                                 |                | Override default readiness probe                                         | `{}`                 |
| `lifecycle`                                            |                | LifecycleHooks to set additional configuration at startup                | `""`                 |


### cinder Image parameters

| Name                                     | Form title | Description                                       | Value                                  |
| ---------------------------------------- | ---------- | ------------------------------------------------- | -------------------------------------- |
| `image.cinderApiImage.registry`          |            | Moodle image registry                             | `docker.io`                            |
| `image.cinderApiImage.repository`        |            | Moodle image repository                           | `kolla/ubuntu-binary-cinder-api`       |
| `image.cinderApiImage.tag`               |            | Moodle image tag (immutable tags are recommended) | `xena`                                 |
| `image.cinderApiImage.pullPolicy`        |            | Moodle image pull policy                          | `IfNotPresent`                         |
| `image.cinderApiImage.pullSecrets`       |            | Specify docker-registry secret names as an array  | `[]`                                   |
| `image.cinderVolumeImage.registry`       |            | Moodle image registry                             | `docker.io`                            |
| `image.cinderVolumeImage.repository`     |            | Moodle image repository                           | `kolla/ubuntu-binary-cinder-volume`    |
| `image.cinderVolumeImage.tag`            |            | Moodle image tag (immutable tags are recommended) | `xena`                                 |
| `image.cinderVolumeImage.pullPolicy`     |            | Moodle image pull policy                          | `IfNotPresent`                         |
| `image.cinderVolumeImage.pullSecrets`    |            | Specify docker-registry secret names as an array  | `[]`                                   |
| `image.cinderSchedulerImage.registry`    |            | Moodle image registry                             | `docker.io`                            |
| `image.cinderSchedulerImage.repository`  |            | Moodle image repository                           | `kolla/ubuntu-binary-cinder-scheduler` |
| `image.cinderSchedulerImage.tag`         |            | Moodle image tag (immutable tags are recommended) | `xena`                                 |
| `image.cinderSchedulerImage.pullPolicy`  |            | Moodle image pull policy                          | `IfNotPresent`                         |
| `image.cinderSchedulerImage.pullSecrets` |            | Specify docker-registry secret names as an array  | `[]`                                   |
| `image.cinderBackupImage.registry`       |            | Moodle image registry                             | `docker.io`                            |
| `image.cinderBackupImage.repository`     |            | Moodle image repository                           | `kolla/ubuntu-binary-cinder-backup`    |
| `image.cinderBackupImage.tag`            |            | Moodle image tag (immutable tags are recommended) | `xena`                                 |
| `image.cinderBackupImage.pullPolicy`     |            | Moodle image pull policy                          | `IfNotPresent`                         |
| `image.cinderBackupImage.pullSecrets`    |            | Specify docker-registry secret names as an array  | `[]`                                   |
| `image.entrypointImage.registry`         |            | Moodle image registry                             | `quay.io`                              |
| `image.entrypointImage.repository`       |            | Moodle image repository                           | `airshipit/kubernetes-entrypoint`      |
| `image.entrypointImage.tag`              |            | Moodle image tag (immutable tags are recommended) | `v1.0.0`                               |
| `image.entrypointImage.pullPolicy`       |            | Moodle image pull policy                          | `IfNotPresent`                         |
| `image.entrypointImage.pullSecrets`      |            | Specify docker-registry secret names as an array  | `[]`                                   |
| `image.cinderLoopImage.registry`         |            | Moodle image registry                             | `docker.io`                            |
| `image.cinderLoopImage.repository`       |            | Moodle image repository                           | `docker/loop`                          |
| `image.cinderLoopImage.tag`              |            | Moodle image tag (immutable tags are recommended) | `latest`                               |
| `image.cinderLoopImage.pullPolicy`       |            | Moodle image pull policy                          | `IfNotPresent`                         |
| `image.cinderLoopImage.pullSecrets`      |            | Specify docker-registry secret names as an array  | `[]`                                   |
| `image.kollaToolboxImage.registry`       |            | Moodle image registry                             | `docker.io`                            |
| `image.kollaToolboxImage.repository`     |            | Moodle image repository                           | `kolla/ubuntu-binary-kolla-toolbox`    |
| `image.kollaToolboxImage.tag`            |            | Moodle image tag (immutable tags are recommended) | `xena`                                 |
| `image.kollaToolboxImage.pullPolicy`     |            | Moodle image pull policy                          | `IfNotPresent`                         |
| `image.kollaToolboxImage.pullSecrets`    |            | Specify docker-registry secret names as an array  | `[]`                                   |


### Cinder config file

| Name                      | Form title   | Description                             | Value                                       |
| ------------------------- | ------------ | --------------------------------------- | ------------------------------------------- |
| `conf.create_loop_device` | 创建loop设备     | 是否创建loop设备                              | `true`                                      |
| `conf.loop_name`          | loop 设备名称    | cinder 后端存储创建的 loop 设备名称                | `/dev/loop0`                                |
| `conf.dd_lvm_bs`          | loop 设备bs    | cinder 后端存储创建的 loop 设备 bs 大小 默认为1M      | `1M`                                        |
| `conf.dd_lvm_count`       | loop 设备count | cinder 后端存储创建的 loop 设备 count 次数 默认为2048 | `2048`                                      |
| `conf.kolla_log_dir`      | kolla 日志目录   | 存放 kolla 日志文件的目录                        | `/var/log/kolla/cinder`                     |
| `conf.volume_type`        | cinder 卷类型   | cinder 后端存储的卷类型，默认为lvm                  | `lvm1`                                      |
| `conf.vg_name`            | vg 名称        | cinder 后端存储所创建的卷组名                      | `cinder-volumes`                            |
| `conf.volume_driver`      | cinder 卷驱动   | cinder 后端存储驱动，默认为lvm                    | `cinder.volume.drivers.lvm.LVMVolumeDriver` |


### Traffic Exposure Parameters

| Name                                | Form title | Description                                                                   | Value                    |
| ----------------------------------- | ---------- | ----------------------------------------------------------------------------- | ------------------------ |
| `service.cluster_domain_suffix`     |            | Kubernetes Service suffix                                                     | `cluster.local`          |
| `service.type`                      |            | Kubernetes Service type                                                       | `ClusterIP`              |
| `service.publicService.name`        |            | cinder public svc name                                                        | `cinder-api`             |
| `service.publicService.port`        |            | cinder public svc port                                                        | `8776`                   |
| `service.publicService.portname`    |            | cinder public svc port name                                                   | `ks-pub`                 |
| `service.internalService.name`      |            | cinder internal svc name                                                      | `cinder`                 |
| `service.internalService.httpPort`  |            | cinder internal svc http port                                                 | `80`                     |
| `service.internalService.httpName`  |            | cinder internal svc http port name                                            | `http`                   |
| `service.internalService.httpsPort` |            | cinder internal svc https port                                                | `443`                    |
| `service.internalService.httpsName` |            | cinder internal svc https port name                                           | `https`                  |
| `service.nodePorts.http`            |            | Node port for HTTP                                                            | `""`                     |
| `service.nodePorts.https`           |            | Node port for HTTPS                                                           | `""`                     |
| `service.clusterIP`                 |            | Cluster internal IP of the service                                            | `""`                     |
| `service.loadBalancerIP`            |            | cinder service Load Balancer IP                                               | `""`                     |
| `service.externalTrafficPolicy`     |            | cinder service external traffic policy                                        | `Cluster`                |
| `ingress.enabled`                   |            | Enable ingress record generation for cinder                                   | `true`                   |
| `ingress.pathType`                  |            | Ingress path type                                                             | `ImplementationSpecific` |
| `ingress.apiVersion`                |            | Force Ingress API version (automatically detected if not set)                 | `""`                     |
| `ingress.ingressClassName`          |            | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+) | `nginx`                  |
| `ingress.hostname`                  |            | Default host for the ingress record                                           | `cinder`                 |
| `ingress.path`                      |            | Default path for the ingress record                                           | `/`                      |


### Keystone Details

| Name                                              | Form title           | Description                   | Value                |
| ------------------------------------------------- | -------------------- | ----------------------------- | -------------------- |
| `keystone.enabled`                                | 部署 keystone          | 是否部署keystone                  | `true`               |
| `keystone.endpoints.auth.admin.os_auth_url`       | keystone publicUrl   | 访问keystone的public endpoints   | `""`                 |
| `keystone.endpoints.auth.admin.os_internal_url`   | keystone internalUrl | 访问keystone的internal endpoints | `""`                 |
| `keystone.openstack-dep.enabled`                  | 部署 openstack 依赖环境    | 是否部署 openstack 依赖环境           | `true`               |
| `keystone.openstack-dep.gen-password.secretName`  | Secret Name          | openstack 环境密码的 secret 名称     | `openstack-password` |
| `keystone.openstack-dep.openstackEnv.rabbitmqUrl` | 部署 openstack 依赖环境    | 访问rabbitmq的Url，格式：rabbitmq    | `""`                 |
| `keystone.openstack-dep.openstackEnv.mariadbUrl`  | 部署 openstack 依赖环境    | 是否部署 openstack 依赖环境           | `""`                 |
| `keystone.openstack-dep.openstackEnv.memcacheUrl` | 部署 openstack 依赖环境    | 是否部署 openstack 依赖环境           | `""`                 |
