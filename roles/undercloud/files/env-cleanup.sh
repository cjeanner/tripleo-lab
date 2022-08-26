#!/bin/sh
sudo podman rm -fa
sudo podman rmi -fa
sudo rm -rf /var/lib/config-data/ \
  /var/lib/docker-puppet/ \
  /var/lib/rabbitmq \
  /var/lib/mysql/ \
  /var/lib/pacemaker/* \
  /var/lib/image-serve/* \
  /etc/nftables/tripleo-chains.nft \
  /etc/nftables/tripleo-flushes.nft \
  /etc/nftables/tripleo-jumps.nft \
  /etc/nftables/tripleo-rules.nft \
  /etc/nftables/tripleo-update-jumps.nft \
  /etc/nftables/iptables.nft \
  /home/stack/*
sudo nft flush ruleset
sudo sed -i '/^include /d' /etc/sysconfig/nftables.conf
sudo systemctl disable --now nftables
