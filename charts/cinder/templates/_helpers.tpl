{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper cinder api image name
*/}}
{{- define "cinder.api.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.cinderApiImage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kiam.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Kubernetes Entrypoint image name
*/}}
{{- define "entrypoint.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.entrypointImage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper cinder volume image name
*/}}
{{- define "cinder.volume.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.cinderVolumeImage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper cinder scheduler image name
*/}}
{{- define "cinder.scheduler.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.cinderSchedulerImage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper cinder backup image name
*/}}
{{- define "cinder.backup.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.cinderBackupImage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper cinder loop image name
*/}}
{{- define "cinder.loop.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.cinderLoopImage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper kolla toolbox image name
*/}}
{{- define "kolla.toolbox.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image.kollaToolboxImage "global" .Values.global) -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cinder.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the MariaDB Hostname
*/}}

{{- define "cinder.databaseHost" -}}
{{- if (index .Values "keystone" "openstack-dep" "enabled") }}
    {{- if eq (index .Values "keystone" "openstack-dep" "mariadb" "architecture") "replication" }}
        {{- printf "%s-primary" (include "cinder.mariadb.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "cinder.mariadb.fullname" .) -}}
    {{- end -}}
{{- else -}}
    {{- $url := regexSplit ":" (index .Values "keystone" "openstack-dep" "openstackEnv" "mariadbUrl") -1 }}
    {{- $host := index $url 0 }}
    {{- printf $host }}
{{- end -}}
{{- end -}}

{{/*
Return the MariaDB Password
*/}}
{{- define "cinder.databasePassword" -}}
{{- if (index .Values "keystone" "openstack-dep" "enabled") }}
    {{- printf "%s" (index .Values "keystone" "openstack-dep" "gen-password" "passwordEnvs" "cinder-database-password" | b64dec) -}}
{{- else -}}
    {{- printf "%s" .Values.endpoints.oslo_db.db_password_placeholder -}}
{{- end -}}
{{- end -}}

{{/*
Return the cinder.keystone.password
*/}}
{{- define "cinder.keystone.password" -}}
{{- if (index .Values "keystone" "openstack-dep" "enabled") }}
    {{- printf "%s" (index .Values "keystone" "openstack-dep" "gen-password" "passwordEnvs" "cinder-keystone-password" | b64dec) -}}
{{- else -}}
    {{- printf "%s" .Values.endpoints.auth.cinder.db_password_placeholder -}}
{{- end -}}
{{- end -}}

{{/*
Return the cinder.internal.endpoints
*/}}
{{- define "cinder.internal.endpoints" -}}
    {{- $internalService := .Values.service.publicService.name }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.service.cluster_domain_suffix }}
    {{- printf "http://%s.%s.svc.%s:%d/v3" $internalService $releaseNamespace $clusterDomain (.Values.service.publicService.port | int) }}
{{- end }}

{{/*
Return the cinder.public.endpoints
*/}}
{{- define "cinder.public.endpoints" -}}
    {{- $publicService := .Values.service.internalService.name }}
    {{- $publicPort := .Values.service.internalService.httpPort }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.service.cluster_domain_suffix }}
    {{- printf "http://%s.%s.svc.%s/v3" $publicService $releaseNamespace $clusterDomain }}
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