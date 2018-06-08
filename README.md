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
ansible-playbook builder.yaml
```

It will deploy a containerized undercloud and prepare the baremetal.json file you will
use in order to register nodes in ironic.

### Redeploy the lab
If you issue a ```lab-destroy``` on the builder, you will need to redeploy the lab:
```Bash
ansible-playbook builder.yaml --tags lab
```

### I have my undercloud - may I deploy the overcloud images
Yes !
```Bash
ansible-playbook builder.yaml --tags overcloud-images
```
### Extend the lab
You can pass variables and environment files using the ```-e``` option, like:
```Bash
ansible-playbook builder.yaml --skip-tags overcloud-images --tags lab -e @environments/3ctl-1compute.yaml
```
This will start a lab with just 3 controllers and 1 compute.

#### Variables
*vms*
  Hash with the following entries:
  - name (string)
  - cpu (int)
  - memory (int, MB)
  - interfaces (list)
    - mac (MAC address)
  - autostart (bool)

*virt_user*
  Username on the builder (will be created)

*basedir*
  Base directory for all the VM images

*undercloud_password*
  Root password on the undercloud VM (debug purpose)

*tripleo_repo_version*
  Tripleo-repos package name/version

*tripleo_version*
  Tripleo version name

*overcloud_images*
  Hash with the following entries:
  - file (string)
  - content (string)

*containerized_undercloud*
  Boolean

*ci_tools*
  Install CI tools (Boolean)
