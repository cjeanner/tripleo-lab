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
