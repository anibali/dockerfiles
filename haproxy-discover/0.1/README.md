### HAProxy Docker image

[Alpine Linux](http://www.alpinelinux.org/) + [HAProxy](http://www.haproxy.org/)

`docker pull anibali/haproxy-discover`

This is a light-weight image that provides a HAProxy install with service
discovery using [Registrator](http://gliderlabs.com/registrator/latest/).
The only registry backend supported currently is etcd.

Typical setup:

* One or more nodes running an etcd cluster
* For each type of service,
  * One or more nodes each running an instance of the service and Registrator
    (connected to etcd)
  * One node running anibali/haproxy-discover for the service (connected to
    etcd). In some cases you may want to run multiple of these for redundancy

#### Usage

```sh
$ docker run --rm -p 80:80 -p 1936:1936 anibali/haproxy-discover \
  --service=hello --port=80 --registry="etcd://1.2.3.4:2379/services"
```

Sets up HAProxy to round robin between all discovered "hello" services that have
port 80 published. The proxy port is the same as the service port (80 in this
case). In this example it is assumed that Registrator has been set up to
register services with etcd, which is running at address 1.2.3.4.

HAProxy stats are available on port 1936.
