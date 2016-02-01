### LDoc Docker image

[Alpine Linux](http://www.alpinelinux.org/) +
[LDoc](https://github.com/stevedonovan/LDoc)

`docker pull anibali/ldoc`

* Contains Lua 5.2
* Contains LDoc, a tool for generating Lua documentation

#### Usage

The recommended way to use this container is to create a shell alias in
`.bashrc` or `.zshrc`. This can be achieved with the following line.

```sh
alias ldoc='docker run --rm -it -v $PWD:/app -u "$UID:$GID" anibali/ldoc'
```

With the alias set up, you can just use the `ldoc` command like normal.

```
$ ldoc --help
```
