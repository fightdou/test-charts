#!/bin/bash
set -ex
openstack volume type create {{ .Values.conf.volume_type }}