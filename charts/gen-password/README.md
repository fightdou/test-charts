# Automatic Genrate Openstack Password

## Parameters

### 自动生成openstack keystone 和 mariadb 密码

| Name            | Description                                     | Value  |
| --------------- | ----------------------------------------------- | ------ |
| `autoGenPasswd` | 配置是否自动生成密码，true 代表自动生成，如果为 false 则需自己手动配置以下相关密码 | `true` |


### Auto generate relate password

| Name                                         | Description         | Value |
| -------------------------------------------- | ------------------- | ----- |
| `passwordConfig.mariadb-root-password`       | 数据库 root 用户密码       | `""`  |
| `passwordConfig.keystone-database-password`  | Keystone 数据库密码      | `""`  |
| `passwordConfig.keystone-admin-password`     | Keystone admin 用户密码 | `""`  |
| `passwordConfig.glance-database-password`    | Glance 数据库密码        | `""`  |
| `passwordConfig.glance-keystone-password`    | Glance 用户密码         | `""`  |
| `passwordConfig.cinder-database-password`    | Cinder 数据库密码        | `""`  |
| `passwordConfig.cinder-keystone-password`    | Cinder 用户密码         | `""`  |
| `passwordConfig.neutron-database-password`   | Neutron 数据库密码       | `""`  |
| `passwordConfig.neutron-keystone-password`   | Neutron 用户密码        | `""`  |
| `passwordConfig.nova-database-password`      | Nova 数据库密码          | `""`  |
| `passwordConfig.nova-keystone-password`      | Nova 用户密码           | `""`  |
| `passwordConfig.placement-database-password` | Placement 数据库密码     | `""`  |
| `passwordConfig.placement-keystone-password` | Placement 用户密码      | `""`  |
