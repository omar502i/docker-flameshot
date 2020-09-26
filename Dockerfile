FROM debian:stable-slim
# FROM bitnami/minideb:stretch
# FROM bitnami/minideb:jessie

LABEL maintainer="@ManuelLR <manuellr.git@gmail.com>"

ENV GIT_URL https://github.com/flameshot-org/flameshot.git
ENV GIT_BRANCH v0.8.1

ENV BUILD_PACKAGES git g++ cmake build-essential qt5-default qttools5-dev-tools libqt5svg5-dev qttools5-dev
ENV RUNTIME_PACKAGES libqt5dbus5 libqt5network5 libqt5core5a libqt5widgets5 libqt5gui5 libqt5svg5 openssl ca-certificates

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /usr/src/

RUN set -x \
    && apt update \
    && apt install -y $BUILD_PACKAGES \
    && cd /usr/src/ \
    && git clone $GIT_URL flameshot --branch $GIT_BRANCH \
    && cd flameshot \
    && cmake && make -j 3 && make install && make clean \
    && apt-get remove --purge --auto-remove -y $BUILD_PACKAGES \
    && apt-get install -y $RUNTIME_PACKAGES \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/src/flameshot /usr/bin/flameshot

CMD flameshot
