#!/bin/bash
set -ex
vgremove -y {{ .Values.conf.vg_name }}
pvremove {{ .Values.conf.loop_name }}
{{- if .Values.conf.create_loop_device }}
losetup -d {{ .Values.conf.loop_name }}
{{- end }}
