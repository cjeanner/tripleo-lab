# Custom Lab for TripleO
A simple way to bootstrap a bunch of VMs on a libvirt host. Gives more control
than quickstart in some cases.

## Installation
Please run the following command in order to get "tripleo operator" collection:

```Bash
ansible-playbook config-host.yaml
```

## Specs
It is expected to run the following resources:
- 1 undercloud
- 3 controllers
- 2 computes
- 3 ceph-storage

The amount of used memory for that env is about 52G, and about 20 CPU cores.

## Prerequisite
### Working ssh-agent on ansible-host
A working ssh-agent must be runnin on the host launching ansible playbook. It
is needed in order to hot-load the private ssh key for the undercloud access.

In case you're running the playbook for a "middle machine", you can just forward
the agent from your workstation.

## Usage
### Standard deploy:
```Bash
ansible-playbook builder.yaml
```

It will deploy a containerized undercloud and prepare the baremetal.json file
you will use in order to register nodes in ironic.

### Redeploy the lab
If you issue a ```lab-destroy``` on the builder, you will need to redeploy the
lab:
```Bash
ansible-playbook builder.yaml --tags lab
```

### I have my undercloud and want to replay only specific tasks on it
Just limit with the tags, and be sure to have the ```inventory``` tag. For
example, in order to just manage the overcloud images:
```Bash
ansible-playbook builder.yaml -t inventory,overcloud-images
```

### I want to add a new instance to my current lab
Just add the requested information in the yaml you used for the initial deploy,
then:
```Bash
ansible-playbook builder.yaml -t domains -t baremetal -t vbmc
```

Domain tag will create the instance disk image and add it to libvirt. The vbmc
tag will add the new to vbmc, and enable it. The baremetal tag will take care of
the different configuration on the undercloud.

One note though: you might want to delete the already-existing node(s) from the
baremetal.json on the undercloud, in order to avoid useless error output from
the import task.

Also, this ansible will NOT run the import task once more, it doesn't ensure
all nodes are present. You will need to run, on your own:
```Bash
source ~/stackrc
openstack overcloud node import --provide baremetal.json
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
    - network (network name, default 'ctlplane')
  - autostart (bool)
  - swap (string, for example 10G)
  - iotune (list)
    - tune (string, iotune option)
      value (string, iotune option value)
```YAML
vms:
  - name: undercloud
    cpu: 16
    memory: 20000
    disksize: 100
    interfaces:
      - network: default
      - net2
    autostart: true
  - name: controller-0
    cpu: 8
    memory: 20000
    disksize: 100
    interfaces:
      - net1
      - net2
    autostart: false
```

*virt_user*
  Username on the builder (will be created)

*basedir*
  Base directory for all the VM images

*undercloud_password*
  Root password on the undercloud VM (debug purpose)

*undercloud_config*
  List of hashes representing ini configuration for undercloud.conf file
```YAML
---
undercloud_config:
  - section: DEFAULT
    option: container_cli
    value: podman
```

*tripleo_repo_version*
  Tripleo-repos package name/version. The default version is `master`. This can be changed this to any OpenStack version, like `stein` or `train`.

*overcloud_images*
  Hash with the following entries:
  - file (string)
  - content (string)

*containerized_undercloud*
  Boolean, default "yes"

*use_heat*
  Whether to add `--use-heat` to undercloud install command (Boolean).
  Defaults "no"

*deploy_undercloud*
  Boolean

*deploy_overcloud*
  Boolean

*proxy_host*
  Allows to use a proxy on the lab - put IP:PORT as value

*synchronize*
  List of hashes with the following entries:
  - name
  - base
  - container (optional, default False)
  - host (optional, default True)
  - dest (defaults to /home/stack/tripleo/)
  Synchronize with rsync from your ansible controller to remote. The "host"
  and "container" params are used for the build destiation - either container
  or host, or both. It results in a different target directory.
```YAML
synchronize:
  - name: tripleo-heat-templates
    base: /home/user/work
    dest: /home/stack/tripleo/
```

*synchronize_default_dest*
  String. Used if you don't set "dest" in the synchronize hash.
  Default /home/stack/tripleo/

*custom_rpms*
  List of custom remote RPMS to install on your undercloud node

*additional_envs*
  List of additional env you want to pass to either standalone or overcloud deploy

*standalone*
  Deploy "standalone" tripleo (Bool, default no)

*standalone_ceph*
  Deploy ceph in standalone tripleo (Bool, default no)

*standalone_container_cli*
  Deploy standalone using said container CLI (String, default docker)

*deploy_standalone*
  Run the deploy script (Bool, default yes)

*semodules*
  Build modules based on .te files you can provide. List of dicts.
```YAML
semodules:
  - name: foobar
    src: /full/path/foobar.te
```

*overcloud_image_update*
  Whether you want to get a `yum update` on the overcloud-full prior its
  upload into Glance. (Bool, default to yes)

*undercloud_low_memory*
  Creates a hieradata file to configure 1 worker per OpenStack
  service. This hieradata file is consummed by the Undercloud.
  (Bool, default no)

*disable_selinux*
  Allows to disable selinux on the undercloud, setting it to "permissive" while
  still logging what would have been blocked.
  (Bool, default no)

*custom_repositories*
  List of custom repositories dicts
```YAML
custom_repositories:
  - name: foo
    file: (string, optional)
    uri: https://foo.bar
    gpg: (bool, optional)
    priority: (int, optional)
```

*tripleoclient_pkgname*
  Allows to set a custom name for the python-tripleoclient.
  (Str, default python-tripleoclient)

*unmanage_iface*
  Point to the interface we want to unmanage from NetworkManager

*container_prepare_overrides*
  Dict of overrides for the default container-image-prepare.
```YAML
container_prepare_overrides:
  tag: my-test-tag
  namespace: my.container.registry/rh-osbs
  name_prefix: tripleo-
  ceph_namespace: my.ceph.registry/ceph
  ceph_tag: latest
  ceph_image: myceph_image
```

*num_osds*
  The number of OSD disks created per ceph node (int, default 1)

*stack_ssh_keys*
  Additional ssh keys you want to add on the undercloud "stack" user
