#!/bin/bash -e

host_ip="$(hostname -i)"

# Try to configure etcd automatically if not configured by user
export ETCD_ADVERTISE_CLIENT_URLS=${ETCD_ADVERTISE_CLIENT_URLS:-"http://$host_ip:2379"}
export ETCD_LISTEN_CLIENT_URLS=${ETCD_LISTEN_CLIENT_URLS:-"http://0.0.0.0:2379"}
# export ETCD_INITIAL_ADVERTISE_PEER_URLS=${ETCD_INITIAL_ADVERTISE_PEER_URLS:-"http://$host_ip:2380"}
# export ETCD_LISTEN_PEER_URLS=${ETCD_LISTEN_PEER_URLS:-"http://0.0.0.0:2380"}

etcd "$@"
