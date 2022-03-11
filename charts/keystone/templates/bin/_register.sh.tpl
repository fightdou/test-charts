#!/bin/bash
set -ex

/opt/ansible/bin/ansible localhost -m os_keystone_service \
    -a "name=keystone service_type=identity region_name=RegionOne"
/opt/ansible/bin/ansible localhost -m os_keystone_service \
    -a "name=keystone service_type=identity region_name=RegionOne"
/opt/ansible/bin/ansible localhost -m os_keystone_service \
    -a "name=keystone service_type=identity region_name=RegionOne"

/opt/ansible/bin/ansible localhost -m os_keystone_endpoint \
    -a "service=keystone url=$OS_BOOTSTRAP_ADMIN_URL endpoint_interface=admin region=RegionOne region_name=RegionOne"
/opt/ansible/bin/ansible localhost -m os_keystone_endpoint \
    -a "service=keystone url=$OS_AUTH_URL endpoint_interface=internal region=RegionOne region_name=RegionOne"
/opt/ansible/bin/ansible localhost -m os_keystone_endpoint \
    -a "service=keystone url=$OS_BOOTSTRAP_ADMIN_URL endpoint_interface=public region=RegionOne region_name=RegionOne"
