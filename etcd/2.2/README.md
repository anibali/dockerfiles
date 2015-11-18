### etcd Docker image

[Alpine Linux](http://www.alpinelinux.org/) + [etcd](https://coreos.com/etcd/)

`docker pull anibali/etcd`

* Includes `etcd` and `etcdctl` binaries

#### Usage

```sh
$ docker run -d -p 2379:2379 --name etcd anibali/etcd
d3ebaca8722f98a761bd65504e1084bb00cbddfa2ac1f4d322ff2cd4f811829b
$ docker run --rm --net=host anibali/etcd etcdctl set greeting hello
hello
$ docker run --rm --net=host anibali/etcd etcdctl get greeting
hello
$ docker stop etcd && docker rm etcd
etcd
etcd
```
