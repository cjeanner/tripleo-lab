#!/bin/bash

source ~/stackrc
openstack overcloud container image prepare \
  --output-env-file ~/overcloud-yml/containers-env-file.yaml

openstack overcloud deploy \
  --templates /usr/share/openstack-tripleo-heat-templates/ \
  --environment-directory ~/overcloud-yml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/disable-telemetry.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/docker.yaml \
  --ntp-server pool.ntp.org \
  --config-download
ret_val=$?

if [ $ret_val -ne 0 ] && [ -n $1 ] && [ $1 == '--delete-if-fail' ]; then
  openstack stack delete --yes --wait overcloud
fi
