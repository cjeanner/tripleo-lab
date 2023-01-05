#!/bin/bash -e

test -f /home/stack/prepare-edpm.log && mv /home/stack/prepare-edpm.log /home/stack/prepare-edpm.log.$(date +%F-%R)
ansible-playbook -i /home/stack/tripleo-deploy/edpm-inventory/ /home/stack/edpm-prepare-playbook.yaml >&1 | tee /home/stack/prepare-edpm.log

test -f /home/stack/deploy-edpm.log && mv /home/stack/deploy-edpm.log /home/stack/deploy-edpm.log.$(date +%F-%R)
sudo ansible-playbook -i /home/stack/tripleo-deploy/edpm-inventory/ \
  -e @/home/stack/edpm-compute-parameters.yaml \
  /usr/share/ansible/tripleo-playbooks/deploy-overcloud-compute.yml 2>&1 | tee /home/stack/deploy-edpm.log
