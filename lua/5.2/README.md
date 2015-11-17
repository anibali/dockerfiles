### Lua image

[Alpine Linux](http://www.alpinelinux.org/) + [Lua](http://www.lua.org/) +
[LuaRocks](https://luarocks.org/)

`docker pull anibali/lua`

* Contains curl
* Contains Lua 5.2
* Contains LuaRocks, the package manager for Lua modules

#### Usage

##### Running a container

```sh
$ docker run --rm -it anibali/lua
Lua 5.2.4  Copyright (C) 1994-2015 Lua.org, PUC-Rio
> = 6 * 7
42
> os.exit(0)
```

##### Using as a base image

When using LuaRocks, be aware that many modules require a compiler. This
requires us to temporarily add a few extra packages to our image.

For example, if we wanted to add the "httpclient" and "lua-cjson" modules to our
image then we would add the following to our Dockerfile:

```
RUN apk add --update gcc lua5.2-dev musl-dev git \
    && export C_INCLUDE_PATH=/usr/include/lua5.2/ \
    && luarocks install httpclient \
    && luarocks install lua-cjson \
    && apk del gcc lua5.2-dev musl-dev git \
    && rm -rf /var/cache/apk/*
```
