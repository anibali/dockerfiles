FROM anibali/alpine-tini:3.2

ENV ETCD_GIT_TAG=v2.2.1

RUN apk add --update curl git go \
    && mkdir -p /usr/src/etcd \
    && git clone https://github.com/coreos/etcd.git /usr/src/etcd \
    && cd /usr/src/etcd \
    && git checkout tags/$ETCD_GIT_TAG \
    && ./build \
    && cp /usr/src/etcd/bin/* /usr/bin \
    && rm -rf /usr/src/etcd \
    && apk del curl git go \
    && rm -rf /var/cache/apk/*

EXPOSE 2379
EXPOSE 2380

CMD ["etcd", "--bind-addr=0.0.0.0:2379", "--peer-bind-addr=0.0.0.0:2380"]
