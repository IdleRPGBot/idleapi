FROM docker.io/crystallang/crystal:latest-alpine AS builder

RUN sed -i "s:v3.11:edge:g" /etc/apk/repositories && \
    apk upgrade --no-cache

WORKDIR /build
COPY . .

RUN make build-static

FROM docker.io/library/busybox

COPY --from=builder /build/bin/idleapi /idleapi

CMD /idleapi
