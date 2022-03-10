{{- define "common.manifests.job_cm_render" -}}
{{- $envAll := index . "envAll" -}}
{{- $serviceName := index . "serviceName" -}}
{{- $jobAnnotations := index . "jobAnnotations" -}}
{{- $dbUserPasswordName := index . "dbUserPasswordName" -}}
{{- $configMapBin := index . "configMapBin" | default (printf "%s-%s" $serviceName "bin" ) -}}
{{- $configMapEtc := index . "configMapEtc" | default (printf "%s-%s" $serviceName "etc" ) -}}
{{- $podEnvVars := index . "podEnvVars" | default false -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ printf "%s-%s" $serviceName "cm-render" | quote }}
  namespace: {{ $envAll.Release.Namespace | quote }}
  annotations:
{{- if $jobAnnotations }}
{{ toYaml $jobAnnotations | indent 4 }}
{{- end }}
spec:
  template:
    spec:
      containers:
        - name: {{ printf "%s-%s" $serviceName "cm-render" | quote }}
          image: {{ include "common.images.image" (dict "imageRoot" $envAll.Values.image.kollaToolbox "global" $envAll.Values.global) | quote }}
          imagePullPolicy: {{ $envAll.global.pullPolicy }}
          command:
            - /bin/sh
            - -c
            - python3 {{ printf "%s/%s-%s" "/tmp" $serviceName "cm-render.py" | quote }}
          env:
            - name: KUBERNETES_NAMESPACE
              value: {{ $envAll.Release.Namespace }}
            - name: CONFIG_MAP_NAME
              value: {{ printf "%s-%s" $serviceName "etc" | quote }}
            - name: DB_NAME
              value: {{ $envAll.Values.endpoints.oslo_db.database | quote }}
            - name: DB_USERNAME
              value: {{ $envAll.Values.endpoints.oslo_db.username | quote }}
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: {{ $dbUserPasswordName | quote }}
                  name: {{ index $envAll.Values "openstack-dep" "gen-password" "secretName" }}
            - name: MARIADB_URL
              valueFrom:
                secretKeyRef:
                  key: MARIADB_URL
                  name: {{ index $envAll.Values "openstack-dep" "connInfoSecret" }}
            - name: RABBITMQ_URL
              valueFrom:
                secretKeyRef:
                  key: RABBITMQ_URL
                  name: {{ index $envAll.Values "openstack-dep" "connInfoSecret" }}
            - name: MEMCACHE_URL
              valueFrom:
                secretKeyRef:
                  key: MEMCACHE_URL
                  name: {{ index $envAll.Values "openstack-dep" "connInfoSecret" }}
{{- if $podEnvVars }}
{{ $podEnvVars | toYaml | indent 12 }}
{{- end }}
          volumeMounts:
            - mountPath: /tmp
              name: pod-tmp
            - mountPath: {{ printf "%s/%s-%s" "/tmp" $serviceName "cm-render.py" | quote }}
              name: {{ $configMapBin | quote }}
              subPath: {{ printf "%s-%s" $serviceName "cm-render.py" | quote }}
            - mountPath: /etc/sudoers.d/kolla_ansible_sudoers
              name: {{ $configMapEtc | quote }}
              subPath: kolla-toolbox-sudoer
      initContainers:
        - name: init
          image: {{ include "common.images.image" (dict "imageRoot" $envAll.Values.image.entrypoint "global" $envAll.Values.global) | quote }}
          imagePullPolicy: {{ $envAll.global.pullPolicy }}
          command:
            - kubernetes-entrypoint
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.name
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.namespace
            - name: PATH
              value: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/
            - name: DEPENDENCY_SERVICE
              value: {{ $envAll.Release.Namespace }}:{{ include "keystone.mariadb.fullname" . }}
      restartPolicy: OnFailure
      serviceAccount: {{ $envAll.Values.serviceAccountName}}
      serviceAccountName: {{ $envAll.Values.serviceAccountName}}
      volumes:
      - emptyDir: {}
        name: pod-tmp
      - configMap:
          defaultMode: 493
          name: {{ $configMapBin | quote }}
        name: {{ $configMapBin | quote }}
      - configMap:
          defaultMode: 365
          name: {{ $configMapEtc | quote }}
        name: {{ $configMapEtc | quote }}
{{- end }}