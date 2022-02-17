{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Keystone image name
*/}}
{{- define "keystone.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.keystoneImage "global") -}}
{{- end -}}

{{/*
Return the proper Kubernetes Entrypoint image name
*/}}
{{- define "entrypoint.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.entrypointImage "global") -}}
{{- end -}}

{{/*
Return the proper Heat image name
*/}}
{{- define "heat.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.heatImage "global") -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "keystone.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the MariaDB Hostname
*/}}
{{- define "keystone.databaseHost" -}}
{{- if (index .Values "openstack-dep" "mariadb" "enabled") }}
    {{- if eq (index .Values "openstack-dep" "mariadb" "architecture") "replication" }}
        {{- printf "%s-primary" (include "keystone.mariadb.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "keystone.mariadb.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Database Name
*/}}
{{- define "keystone.databaseName" -}}
{{- if (index .Values "openstack-dep" "mariadb" "enabled") }}
    {{- printf "%s" .Values.endpoints.oslo_db.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB User
*/}}
{{- define "keystone.databaseUser" -}}
{{- if (index .Values "openstack-dep" "mariadb" "enabled") }}
    {{- printf "%s" .Values.endpoints.oslo_db.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "keystone.databasePort" -}}
{{- if (index .Values "openstack-dep" "mariadb" "enabled") }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for RabbitMQ subchart
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "keystone.rabbitmq.fullname" -}}
{{- if (index .Values "openstack-dep" "rabbitmq" "fullnameOverride") -}}
{{- .Values.rabbitmq.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "rabbitmq" (index .Values "openstack-dep" "rabbitmq" "nameOverride") -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ host
*/}}
{{- define "keystone.rabbitmq.host" -}}
{{- if (index .Values "openstack-dep" "rabbitmq" "enabled") }}
    {{- printf "%s" (include "keystone.rabbitmq.fullname" .) -}}
{{- else -}}
    {{- printf "%s" .Values.externalRabbitmq.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ Port
*/}}
{{- define "keystone.rabbitmq.port" -}}
{{- if (index .Values "openstack-dep" "rabbitmq" "enabled") }}
    {{- printf "%d" ((index .Values "openstack-dep" "rabbitmq" "port") | int ) -}}
{{- else -}}
    {{- printf "%d" (.Values.externalRabbitmq.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ username
*/}}
{{- define "keystone.rabbitmq.user" -}}
{{- if (index .Values "openstack-dep" "rabbitmq" "enabled") }}
    {{- printf "%s" (index .Values "openstack-dep" "rabbitmq" "auth" "username") -}}
{{- else -}}
    {{- printf "%s" .Values.externalRabbitmq.username -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "keystone.memcached.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "memcached" "chartValues" (index .Values "openstack-dep" "memcached") "context" $) -}}
{{- end -}}

{{/*
Return the Memcached Hostname
*/}}
{{- define "keystone.cacheHost" -}}
{{- if (index .Values "openstack-dep" "memcached" "enabled") }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.endpoints.cluster_domain_suffix }}
    {{- printf "%s.%s.svc.%s" (include "keystone.memcached.fullname" .) $releaseNamespace $clusterDomain -}}
{{- else -}}
    {{- printf "%s" .Values.externalCache.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Memcached Port
*/}}
{{- define "keystone.cachePort" -}}
{{- if (index .Values "openstack-dep" "memcached" "enabled") }}
    {{- printf "11211" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalCache.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the keystone.internal.endpoints
*/}}
{{- define "keystone.internal.endpoints" -}}
{{- if not (empty .Values.endpoints.auth.admin) }}
    {{- $internalService := .Values.service.publicService.name }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.endpoints.cluster_domain_suffix }}
    {{- printf "http://%s.%s.svc.%s:%d/v3" $internalService $releaseNamespace $clusterDomain (.Values.service.publicService.port | int) }}
{{- end }}
{{- end }}

{{/*
Return the keystone.public.endpoints
*/}}
{{- define "keystone.public.endpoints" -}}
{{- if not (empty .Values.endpoints.auth.admin) }}
    {{- $publicService := .Values.service.internalService.name }}
    {{- $publicPort := .Values.service.internalService.httpPort }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.endpoints.cluster_domain_suffix }}
    {{- printf "http://%s.%s.svc.%s/v3" $publicService $releaseNamespace $clusterDomain }}
{{- end }}
{{- end }}

{{/*
abstract: |
  Joins a list of values into a comma separated string
values: |
  test:
    - foo
    - bar
usage: |
  {{ include "joinListWithComma" .Values.test }}
return: |
  foo,bar
*/}}
{{- define "joinListWithComma" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}},{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}

{{/*
Get the keystone endpoints secret name
*/}}
{{- define "keystone.endpoints.secretName" -}}
{{- if not (empty .Values.secrets.identity.admin) -}}
  {{- printf "%s" .Values.secrets.identity.admin -}}
{{- else -}}
  {{- printf "%s" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}
