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
Return the proper kolla toolbox image name
*/}}
{{- define "kolla.toolbox.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.kollaToolboxImage "global") -}}
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
{{- if (index .Values "openstack-dep" "enabled") }}
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
{{- if (index .Values "openstack-dep" "enabled") }}
    {{- printf "%s" .Values.endpoints.oslo_db.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB User
*/}}
{{- define "keystone.databaseUser" -}}
{{- if (index .Values "openstack-dep" "enabled") }}
    {{- printf "%s" .Values.endpoints.oslo_db.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Password
*/}}
{{- define "keystone.databasePassword" -}}
{{- if (index .Values "openstack-dep" "enabled") }}
    {{- printf "%s" (index .Values "openstack-dep" "gen-password" "passwordEnvs" "keystone-database-password" | b64dec) -}}
{{- else -}}
    {{- printf "%s" .Values.endpoints.oslo_db.db_password_placeholder -}}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "keystone.databasePort" -}}
{{- if (index .Values "openstack-dep" "enabled") }}
    {{- printf "3306" -}}
{{- else -}}
    {{- printf "%d" (.Values.endpoints.oslo_db.port | int ) -}}
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
