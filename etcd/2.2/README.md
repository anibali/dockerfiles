### etcd Docker image

[![](https://badge.imagelayers.io/anibali/etcd:latest.svg)](https://imagelayers.io/?images=anibali/etcd:latest 'Get your own badge on imagelayers.io')

[Alpine Linux](http://www.alpinelinux.org/) + [etcd](https://coreos.com/etcd/)

* Includes `etcd` and `etcdctl` binaries

#### Usage

```sh
$ docker run -d -p 2379:2379 --name etcd anibali/etcd
d3ebaca8722f98a761bd65504e1084bb00cbddfa2ac1f4d322ff2cd4f811829b
$ docker run --net=host anibali/etcd etcdctl set greeting hello
hello
$ docker run --net=host anibali/etcd etcdctl get greeting
hello
$ docker stop etcd && docker rm etcd
etcd
etcd
```
