#!/bin/bash
set -ex
pvcreate {{ .Values.conf.loop_name }}
vgcreate {{ .Values.conf.vg_name }} {{ .Values.conf.loop_name }}
