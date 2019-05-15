#!/bin/sh
sudo docker rm -f $(docker ps -aq )
sudo podman rm -fa
sudo rm -rf /var/lib/config-data/ \
  /var/lib/docker-puppet/ \
  /var/lib/rabbitmq \
  /var/lib/mysql/ \
  /var/lib/pacemaker/* \
  /var/lib/image-serve/*
