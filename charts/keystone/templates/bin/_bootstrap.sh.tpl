#!/bin/bash
set -ex
kolla_keystone_bootstrap $OS_USERNAME $OS_PASSWORD $OS_PROJECT_NAME admin $OS_BOOTSTRAP_ADMIN_URL $OS_BOOTSTRAP_INTERNAL_URL $OS_BOOTSTRAP_PUBLIC_URL $OS_REGION_NAME