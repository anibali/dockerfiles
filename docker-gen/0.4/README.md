### docker-gen Docker image

[Alpine Linux](http://www.alpinelinux.org/) + [docker-gen](https://github.com/jwilder/docker-gen)

`docker pull anibali/docker-gen`

#### Usage

Print the names of all running Docker containers:

```sh
$ cat > example.tmpl <<EOF
{{range \$key, \$value := .}}
{{$value.Name}}
{{end}}
EOF
$ docker run -d --name some_container anibali/alpine-tini sleep 1000
84df678461dc21073dcbf79875bb177db39db4a1be6d0621b86f921a76945e79
$ docker run --rm --name another_container \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD:/templates anibali/docker-gen docker-gen /templates/example.tmpl
another_container
some_container
$ docker stop some_container && docker rm some_container
some_container
some_container
```
