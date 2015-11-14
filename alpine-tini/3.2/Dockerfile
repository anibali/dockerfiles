FROM alpine:3.2

RUN apk add --update \
    --repository http://dl-1.alpinelinux.org/alpine/edge/testing/ \
    tini \
    bash \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash"]
