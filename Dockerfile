FROM ubuntu:focal-20231128

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
        make \
        wget \
        dpkg-dev \
        libcairo2-dev \
        libjpeg-turbo8-dev \
        libpng-dev \
        libtool-bin \
        uuid-dev \
        libavcodec-dev libavformat-dev libavutil-dev libswscale-dev \
        freerdp2-dev \
        libpango1.0-dev \
        libssh2-1-dev \
        libvncserver-dev \
        libwebsockets-dev \
        libpulse-dev \
        libssl-dev \
        libvorbis-dev \
        libwebp-dev

RUN mkdir /build

COPY docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]
