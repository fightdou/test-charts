{{- define "common.manifests.job_register" -}}
{{- $envAll := index . "envAll" -}}
{{- $serviceName := index . "serviceName" -}}
{{- $jobAnnotations := index . "jobAnnotations" -}}
{{- $configMapBin := index . "configMapBin" | default (printf "%s-%s" $serviceName "bin" ) -}}
{{- $configMapEtc := index . "configMapEtc" | default (printf "%s-%s" $serviceName "etc" ) -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ printf "%s-%s" $serviceName "register" | quote }}
  namespace: {{ $envAll.Release.Namespace | quote }}
  annotations:
{{- if $jobAnnotations }}
{{ toYaml $jobAnnotations | indent 4 }}
{{- end }}
spec:
  template:
    spec:
      containers:
        - name: {{ printf "%s-%s" $serviceName "register" | quote }}
          image: {{ include "common.images.image" (dict "imageRoot" $envAll.Values.image.kollaToolbox "global" $envAll.Values.global) | quote }}
          imagePullPolicy: {{ $envAll.Values.global.pullPolicy }}
          securityContext:
            runAsUser: 0
          command:
            - /bin/sh
            - -c
            - /tmp/register.sh
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
            - name: OS_BOOTSTRAP_ADMIN_URL
              valueFrom:
                secretKeyRef:
                  key: OS_AUTH_URL
                  name: {{ $envAll.Values.endpoints.auth.secretName }}
            - name: OS_AUTH_URL
              valueFrom:
                secretKeyRef:
                  key: OS_INTERNAL_URL
                  name: {{ $envAll.Values.endpoints.auth.secretName }}
            - name: OS_REGION_NAME
              valueFrom:
                secretKeyRef:
                  key: OS_REGION_NAME
                  name: {{ $envAll.Values.endpoints.auth.secretName }}
            - name: OS_INTERFACE
              valueFrom:
                secretKeyRef:
                  key: OS_INTERFACE
                  name: {{ $envAll.Values.endpoints.auth.secretName }}
            - name: OS_ENDPOINT_TYPE
              valueFrom:
                secretKeyRef:
                  key: OS_INTERFACE
                  name: {{ $envAll.Values.endpoints.auth.secretName }}
            - name: OS_PROJECT_DOMAIN_NAME
              valueFrom:
                secretKeyRef:
                  key: OS_PROJECT_DOMAIN_NAME
                  name: {{ $envAll.Values.endpoints.auth.secretName }}
            - name: OS_PROJECT_NAME
              valueFrom:
                secretKeyRef:
                  key: OS_PROJECT_NAME
                  name: {{ $envAll.Values.endpoints.auth.secretName }}
            - name: OS_USER_DOMAIN_NAME
              valueFrom:
                secretKeyRef:
                  key: OS_USER_DOMAIN_NAME
                  name: {{ $envAll.Values.endpoints.auth.secretName }}
            - name: OS_USERNAME
              valueFrom:
                secretKeyRef:
                  key: OS_USERNAME
                  name: {{ $envAll.Values.endpoints.auth.secretName }}
            - name: OS_DEFAULT_DOMAIN
              valueFrom:
                secretKeyRef:
                  key: OS_DEFAULT_DOMAIN
                  name: {{ $envAll.Values.endpoints.auth.secretName }}
          volumeMounts:
            - mountPath: /tmp
              name: pod-tmp
            - mountPath: /tmp/register.sh
              name: {{ $configMapBin | quote }}
              subPath: register.sh
            - mountPath: /etc/sudoers.d/kolla_ansible_sudoers
              name: {{ $configMapEtc | quote }}
              subPath: kolla-toolbox-sudoer
      initContainers:
        - name: init
          image: {{ include "common.images.image" (dict "imageRoot" $envAll.Values.image.entrypoint "global" $envAll.Values.global) | quote }}
          imagePullPolicy: {{ $envAll.Values.global.pullPolicy }}
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
              value: {{ $envAll.Release.Namespace }}:{{ include "common.utils.joinListWithComma" $envAll.Values.dependencies.register.service }}
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
          defaultMode: 365
          name: {{ $configMapEtc | quote }}
        name: {{ $configMapEtc | quote }}
{{- end }}
