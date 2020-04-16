# Some examples and use-cases

## I want to test that patch from gerrit
1. Fetch the wanted patch in your local repository
2. Follow "I want to test that local change on my computer"

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

## I want to customize my tmate
1. create local_envs/tmate.yaml
2. push something like that in it:
```YAML
tmate_config: |
  set -g tmate-server-host "tmate.your-domain.tld"
  set -g tmate-server-port "2200"
  set -g tmate-server-rsa-fingerprint "SHA256:XXXX"
  set -g tmate-server-ed25519-fingerprint "SHA256:YYYY"
```

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

## I want to inject that RPM/patch/other in my containers
Tripleo-lab relies on tripleo-image-modify for this part. In order to
inject things into the container image prior any deploy, you have to know
a bit about the[related doc](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/container_image_prepare.html#modifying-images-during-prepare).

For instance, if you want to build RPM based on a serie of patches and inject
them into a bunch of container images:
1. create ```local_env/patches.yaml```
```YAML
synchronize:
  - name: mistral
    container: true
    base: /home/cjeanner/work/gerrit
    dest: /home/stack/tripleo/
```
2. Create ```local_env/container-modify.yaml```
```YAML
modify_image:
  - push_destiation: true
    includes:
      - mistral-api
      - mistral-engine
      - mistral-event-engine
      - mistral-executor
    modify_role: tripleo-modify-image
    modify_append_tag: '-dev'
    modify_vars:
      tasks_from: rpm_install.yml
      rpms_path: /home/stack/container-rpms
```
3. Run the deploy command, including those two files:
```Bash
ansible-playbook builder.yaml -e @local_env/container-modify.yaml -e @local_env/patches.yaml
```


## I want to deploy Red Hat Director
Please note this is for Red Hat employees and was NOT tested for any other use
1. Create a "rhel.yaml" in local_env directory
2. Add the following content:
```YAML
---
base_image: rhel
rhos_release_repo_url: http://xxxxxx
proxy_host: xx.yy.zz.aa:PORT
undercloud_sample: /usr/share/instack-undercloud/undercloud.conf.sample
# Set up container things
rhos_containers_registry: <some address>
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
