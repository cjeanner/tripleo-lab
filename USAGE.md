# Some examples and use-cases

## I want to test that patch from gerrit
1. Create a "patch.yaml" in ```local_env``` directory
2. Add the following content:
```YAML
---
patches:
  - name: project-name
    refs: xx/yyyyyy/a
```
3. Run the playbook with the following options:
```Bash
ansible-playbook builder.yaml -t lab -e @local_env/patch.yaml
```

## I want to test that local change on my computer
1. Create a "patch.yaml" in ```local_env``` directory
2. Add the following content:
```YAML
---
synchronize:
  - name: project-name
    base: /home/USERNAME/working/base/dir
    dest: /home/stack/tripleo/
```
3. Run the playbook with the following options:
```Bash
ansible-playbook builder.yaml -t lab -e @local_env/patch.yaml
```

## I want to install that RPM in addition
1. Create "rpm.yaml" in ```local_env``` directory
2. Add the following content:
```YAML
custom_rpms:
  - rpm_name
  - https://some/remote/rpm
```
3. Run the playbook with the following options:
```Bash
ansible-playbook builder.yaml -t lab -e @local_env/rpm.yaml
```

## I want to mimic a slow system
1. Create your vm listing and add some [iotune options](https://libvirt.org/formatdomain.html#elementsDisks)
2. Enjoy a slow system
You can take the [./environments/standalone-slow.yaml] as an example. A deploy
generate a constant load of 3-4 with that setup on my builder, ensuring you
will hit any race conditions/timeouts you can find in upstream CI. Although
those values are, probably, a bit too harsh :).

## I want to push some custom semodule
1. Create ```my-module.te``` file somewhere on your system
2. Create ```semodule.yaml``` in ```local_env``` directory
3. Add the following content:
```YAML
semodules:
  - name: my-module
    src: /path/to/my-module.te
```
4. Run the playbook with the following options:
```Bash
ansible-playbook builder.yaml -t lab -e @local_env/semodule.yaml
```

## I want to deploy Red Hat Director
Please note this is for Red Hat employees and was NOT tested for any other use
1. Create a "rhel.yaml" in local_env directory
2. Add the following content:
```YAML
---
base_image: rhel
ci_tools: false
rhos_release_repo_url: http://xxxxxx
proxy_host: xx.yy.zz.aa:PORT
undercloud_sample: /usr/share/instack-undercloud/undercloud.conf.sample
# Set up container things
rhos_containers_registry: <some address>
container_registry_ip: <some IP>
```
3. Run the playbook with the following options:
```Bash
ansible-playbook builder.yaml -t lab -e @local_env/patch.yaml
```

Notes:
- The ```proxy_host``` is discussed in this [blog post](https://cjeanner.github.io/openstack/tripleo/2018/08/07/accessing-private-stuff.html)
- The ```rhos_release``` stuff is internal to Red Hat
- This will not take into account any registration to RHEL
- The ```undercloud_sample``` is mandatory as long as instack-undercloud is used.
