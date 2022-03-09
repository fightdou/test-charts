{{- define "common.manifests.job_db_sync" -}}
{{- $envAll := index . "envAll" -}}
{{- $serviceName := index . "serviceName" -}}
{{- $configMapBin := index . "configMapBin" | default (printf "%s-%s" $serviceName "bin" ) -}}
{{- $configMapEtc := index . "configMapEtc" | default (printf "%s-%s" $serviceName "etc" ) -}}
{{- $serviceNamePretty := $serviceName | replace "_" "-" -}}
{{- $podVolMounts := index . "podVolMounts" | default false -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ printf "%s-%s" $serviceNamePretty "db-sync" | quote }}
  namespace: {{  $envAll.Release.Namespace | quote }}
spec:
  template:
    spec:
      containers:
        - name: {{ printf "%s-%s" $serviceNamePretty "db-sync" | quote }}
          image: {{ include "common.images.image" (dict "imageRoot" $envAll.Values.image.dbSync "global" $envAll.Values.global) | quote }}
          imagePullPolicy: IfNotPresent
          env:
            - name: KOLLA_CONFIG_STRATEGY
              value: "COPY_ALWAYS"
            - name: KOLLA_SERVICE_NAME
              value: "keystone-db-sync"
            - name: PATH
              value: "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            - name: LANG
              value: "en_US.UTF-8"
            - name: KOLLA_BASE_DISTRO
              value: "ubuntu"
            - name: KOLLA_DISTRO_PYTHON_VERSION
              value: "3.8"
            - name: KOLLA_BASE_ARCH
              value: "x86_64"
            - name: SETUPTOOLS_USE_DISTUTILS
              value: "stdlib"
            - name: PS1
              value: "$(tput bold)($(printenv KOLLA_SERVICE_NAME))$(tput sgr0)[$(id -un)@$(hostname -s) $(pwd)]$ "
            - name: DEBIAN_FRONTEND
              value: "noninteractive"
          volumeMounts:
            {{- if $podVolMounts }}
            {{ $podVolMounts | toYaml | indent 14 }}
            {{- end }}
            - mountPath: /tmp
              name: pod-tmp
            - mountPath: /var/log/kolla/keystone
              name: keystonelog
            - mountPath: /var/lib/kolla/config_files/config.json
              name: {{ $configMapEtc | quote }}
              subPath: db-sync.json
            - mountPath: /tmp/db-sync.sh
              name: {{ $configMapBin | quote }}
              subPath: db-sync.sh
      initContainers:
        - name: init
          image: {{ include "common.images.image" (dict "imageRoot" $envAll.Values.image.entrypoint "global" $envAll.Values.global) | quote }}
          imagePullPolicy: IfNotPresent
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
            - name: DEPENDENCY_JOBS
              value: {{ include "common.utils.joinListWithComma" $envAll.Values.dependencies.db_sync.jobs }}
      restartPolicy: OnFailure
      serviceAccount: {{ $envAll.Values.serviceAccountName }}
      serviceAccountName: {{ $envAll.Values.serviceAccountName }}
      volumes:
      - emptyDir: {}
        name: pod-tmp
      - emptyDir: {}
        name: keystonelog
      - configMap:
          defaultMode: 493
          name: {{ $configMapBin | quote }}
        name: {{ $configMapBin | quote }}
      - configMap:
          defaultMode: 365
          name: {{ $configMapEtc | quote }}
        name: {{ $configMapEtc | quote }}
{{- end -}}
