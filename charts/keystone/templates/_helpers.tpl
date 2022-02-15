{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper Keystone image name
*/}}
{{- define "keystone.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global") -}}
{{- end -}}

{{/*
Return the proper Kubernetes Entrypoint image name
*/}}
{{- define "entrypoint.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.entrypointImage "global") -}}
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
{{- if .Values.mariadb.enabled }}
    {{- if eq .Values.mariadb.architecture "replication" }}
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
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB User
*/}}
{{- define "keystone.databaseUser" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Password
*/}}
{{- define "keystone.databasePassword" -}}
{{- if .Values.mariadb.enabled }}
    {{- printf "%s" .Values.mariadb.auth.password -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.password -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "keystone.databasePort" -}}
{{- if .Values.mariadb.enabled }}
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
{{- if .Values.rabbitmq.fullnameOverride -}}
{{- .Values.rabbitmq.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "rabbitmq" .Values.rabbitmq.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ host
*/}}
{{- define "keystone.rabbitmq.host" -}}
{{- if .Values.rabbitmq.enabled }}
    {{- printf "%s" (include "keystone.rabbitmq.fullname" .) -}}
{{- else -}}
    {{- printf "%s" .Values.externalRabbitmq.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ Port
*/}}
{{- define "keystone.rabbitmq.port" -}}
{{- if .Values.rabbitmq.enabled }}
    {{- printf "%d" (.Values.rabbitmq.service.port | int ) -}}
{{- else -}}
    {{- printf "%d" (.Values.externalRabbitmq.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ username
*/}}
{{- define "keystone.rabbitmq.user" -}}
{{- if .Values.rabbitmq.enabled }}
    {{- printf "%s" .Values.rabbitmq.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalRabbitmq.username -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ password
*/}}
{{- define "keystone.rabbitmq.password" -}}
{{- if .Values.rabbitmq.enabled }}
    {{- printf "%s" .Values.rabbitmq.auth.password -}}
{{- else -}}
    {{- printf "%s" .Values.externalRabbitmq.password -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ secret name
*/}}
{{- define "keystone.rabbitmq.secretName" -}}
{{- if .Values.externalRabbitmq.existingPasswordSecret -}}
    {{- printf "%s" .Values.externalRabbitmq.existingPasswordSecret -}}
{{- else if .Values.rabbitmq.enabled }}
    {{- printf "%s" (include "keystone.rabbitmq.fullname" .) -}}
{{- else -}}
    {{- printf "%s-%s" (include "keystone.fullname" .) "externalrabbitmq" -}}
{{- end -}}
{{- end -}}

{{/*
Return the RabbitMQ host
*/}}
{{- define "keystone.rabbitmq.vhost" -}}
{{- if .Values.rabbitmq.enabled }}
    {{- printf "/" -}}
{{- else -}}
    {{- printf "%s" .Values.externalRabbitmq.vhost -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "keystone.memcached.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "memcached" "chartValues" .Values.memcached "context" $) -}}
{{- end -}}

{{/*
Return the Memcached Hostname
*/}}
{{- define "keystone.cacheHost" -}}
{{- if .Values.memcached.enabled }}
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
{{- if .Values.memcached.enabled }}
    {{- printf "11211" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalCache.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the keystone.admin.api
*/}}
{{- define "keystone.admin.api" -}}
{{- $envAll := index . 0 -}}
{{ tuple "identity" "admin" "api" $envAll | include "helm-toolkit.endpoints.keystone_endpoint_uri_lookup" }}
{{- end }}

{{/*
Return the keystone.public.api
*/}}
{{- define "keystone.public.api" -}}
{{- $envAll := index . 0 -}}
{{ tuple "identity" "public" "api" $envAll | include "helm-toolkit.endpoints.keystone_endpoint_uri_lookup" }}
{{- end }}

{{/*
Return the keystone.internal.api
*/}}
{{- define "keystone.internal.api" -}}
{{- $envAll := index . 0 -}}
{{ tuple "identity" "internal" "api" $envAll | include "helm-toolkit.endpoints.keystone_endpoint_uri_lookup" }}
{{- end }}