#!/bin/bash
set -ex
{{- if .Values.conf.ceph.enabled }}
openstack volume type create {{ .Values.conf.ceph.volume_type }}
{{- end }}

{{- if .Values.conf.lvm.enabled }}
openstack volume type create {{ .Values.conf.lvm.volume_type }}
{{- end }}
