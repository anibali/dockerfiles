### Alpine Docker image

[Alpine Linux](http://www.alpinelinux.org/) + [Tini](https://github.com/krallin/tini)

`docker pull anibali/alpine-tini`

* Small image size
* Uses Tini, a very small init program, as its entrypoint
* Contains bash

#### Usage

##### Running a container

```sh
$ docker run --rm -it anibali/alpine-tini
bash-4.3# date
Sat Nov 14 09:07:10 UTC 2015
bash-4.3# exit
exit
```

#### Using as a base image

Leave the ENTRYPOINT as is and override the CMD eith whatever you like.

See [anibali/etcd](https://hub.docker.com/r/anibali/etcd/~/dockerfile/) for an
example.
