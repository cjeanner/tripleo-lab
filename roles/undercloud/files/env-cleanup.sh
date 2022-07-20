#!/bin/sh
sudo podman rm -fa
sudo podman rmi -fa
sudo rm -rf /var/lib/config-data/ \
  /var/lib/docker-puppet/ \
  /var/lib/rabbitmq \
  /var/lib/mysql/ \
  /var/lib/pacemaker/* \
  /var/lib/image-serve/* \
  /etc/nftables/tripleo-*.nft \
  /etc/nftables/iptables.nft \
  /home/stack/*
sudo nft flush ruleset
