# Custom Lab for TripleO
A simple way to bootstrap a bunch of VMs on a libvirt host. Gives more control than quickstart in
some cases.

## Specs
It is expected to run the following resources:
- 1 undercloud
- 3 controllers
- 2 computes
- 3 ceph-storage

The amount of used memory for that env is about 52G, and about 20 CUP cores. For now, no swap is
set in the VMs, but it might come handy for the undercloud node.

## Usage
### Standard deploy:
```Bash
ansible-playbook builder.yaml --skip-tags overcloud-images
```

This will deploy the whole thing, but not manage the overcloud images.
This is mandatory since this playbook will NOT deploy the undercloud (for now).

### Redeploy the lab
If you issue a ```lab-destroy``` on the builder, you will need to redeploy the lab:
```Bash
ansible-playbook builder.yaml --tags lab --skip-tags overcloud-images
```

### I have my undercloud - may I deploy the overcloud images
Yes, but currently the command is only compatible with a containerized undercloud.
```Bash
ansible-playbook builder.yaml --tags overcloud-images
```
### Extend the lab
You can pass variables and environment files using the ```-e``` option, like:
```Bash
ansible-playbook builder.yaml --skip-tags overcloud-images --tags lab -e @mylab.yml
```
