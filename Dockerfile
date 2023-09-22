FROM --platform=${TARGETPLATFORM} alpine:latest

ENV TZ=Europe/Warsaw

WORKDIR /root

ARG TARGETPLATFORM
ARG TAG

COPY xray.sh "${WORKDIR}"/xray.sh

RUN set -ex \ 
    && apk add --no-cache tzdata ca-certificates \
    && mkdir -p /var/log/xray /usr/local/lib/xray /usr/local/etc/xray \
    && ln -sf /dev/stdout /var/log/xray/access.log \
    && ln -sf /dev/stderr /var/log/xray/error.log \
    && chmod +x "${WORKDIR}"/xray.sh \
    && "${WORKDIR}"/xray.sh "${TARGETPLATFORM}" "${TAG}" \
    && rm -fv "${WORKDIR}"/xray.sh

ENTRYPOINT ["/usr/local/bin/xray"]
