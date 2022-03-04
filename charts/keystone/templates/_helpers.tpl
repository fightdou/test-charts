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
Return the proper Kolla toolbox image name
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
    {{- printf "%s" (include "keystone.mariadb.fullname" .) -}}
{{- else -}}
    {{- $url := regexSplit ":" (index .Values "openstack-dep" "openstackEnv" "mariadbUrl") -1 }}
    {{- $host := index $url 0 }}
    {{- printf $host }}
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
