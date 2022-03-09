{{- define "common.manifests.job_db_init" -}}
{{- $envAll := index . "envAll" -}}
{{- $serviceName := index . "serviceName" -}}
{{- $dbUserPasswordName := index . "dbUserPasswordName" -}}
{{- $configMapBin := index . "configMapBin" | default (printf "%s-%s" $serviceName "bin" ) -}}
{{- $configMapEtc := index . "configMapEtc" | default (printf "%s-%s" $serviceName "etc" ) -}}
{{- $serviceNamePretty := $serviceName | replace "_" "-" -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ printf "%s-%s" $serviceNamePretty "db-init" | quote }}
  namespace: {{  $envAll.Release.Namespace | quote }}
spec:
  template:
    spec:
      containers:
        - name: {{ printf "%s-%s" $serviceNamePretty "db-init" | quote }}
          image: {{ include "common.images.image" (dict "imageRoot" $envAll.Values.image.kollaToolbox "global" $envAll.Values.global) | quote }}
          imagePullPolicy: IfNotPresent
          command:
            - /bin/sh
            - -c
            - /tmp/db-init.sh
          env:
            - name: KOLLA_CONFIG_STRATEGY
              value: "COPY_ALWAYS"
            - name: ANSIBLE_LIBRARY
              value: /usr/share/ansible
            - name: KOLLA_SERVICE_NAME
              value: "kolla-toolbox"
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
            - name: DB_PORT
              value: {{ $envAll.Values.endpoints.oslo_db.port | quote }}
            - name: DB_NAME
              value: {{ $envAll.Values.endpoints.oslo_db.database | quote }}
            - name: DB_USER
              value: {{ $envAll.Values.endpoints.oslo_db.username | quote }}
            - name: DB_HOST_NAME
              valueFrom:
                secretKeyRef:
                  key: MARIADB_HOST
                  name: {{ index "$envAll" "Values" "openstack-dep" "connInfoSecret" }}
            - name: DB_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: mariadb-root-password
                  name: {{ index "$envAll" "Values" "openstack-dep" "gen-password" "secretName" }}
            - name: DB_USER_PASSWORD
              valueFrom:
                secretKeyRef:
                  key: {{ $dbUserPasswordName | quote }}
                  name: {{ index "$envAll" "Values" "openstack-dep" "gen-password" "secretName" }}
          volumeMounts:
            - mountPath: /tmp
              name: pod-tmp
            - mountPath: /tmp/db-init.sh
              name: {{ $configMapBin | quote }}
              subPath: db-init.sh
            - mountPath: /etc/sudoers.d/kolla_ansible_sudoers
              name: {{ $configMapEtc | quote }}
              subPath: kolla-toolbox-sudoer
      initContainers:
        - name: init
          image: {{ template "entrypoint.image" . }}
          imagePullPolicy: {{ .Values.image.entrypointImage.pullPolicy }}
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
              value: {{ include "mariadb.fullname" . }}
      restartPolicy: OnFailure
      serviceAccount: {{ $envAll.Values.serviceAccountName }}
      serviceAccountName: {{ $envAll.Values.serviceAccountName }}
      volumes:
      - emptyDir: {}
        name: pod-tmp
      - configMap:
          defaultMode: 493
          name: {{ $configMapBin | quote }}
        name: {{ $configMapBin | quote }}
      - configMap:
          defaultMode: 493
          name: {{ $configMapEtc | quote }}
        name: {{ $configMapEtc | quote }}
{{- end -}}