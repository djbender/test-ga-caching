# syntax=docker/dockerfile:1.4
FROM ubuntu:noble as core
LABEL com.opencontainers.image.authors="djbender"
LABEL org.opencontainers.image.source=https://github.com/djbender/test-ga-caching
ENV DEBIAN_FRONTEND=noninteractive

# Create a 'docker' user
RUN <<EOT
#!/usr/bin/env bash
set -exu
apt-get update
apt-get install --yes --no-install-recommends \
  adduser \
  ca-certificates \
  locales

# create docker user
addgroup --gid 9999 docker
adduser --uid 9999 --gid 9999 --disabled-password --gecos "Docker User" docker
usermod -L docker

update-ca-certificates
# See the Locals heading at https://hub.docker.com/_/ubuntu
# Alias created as some languages (such as ruby) require the extra local
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
[ $(locale -a | grep 'en_US.utf8') == 'en_US.utf8' ]
EOT

# Ensure UTF-8 locale
ENV LANG en_US.utf-8
ENV LANGUAGE en_US:en

# Switch to the 'docker' user
USER docker

# keep backwards compatability with use cases that assume CMD is 'bash' since
# specifying an ENTRYPOINT always clears the CMD that was inheritted by the FROM image
# ref: https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact
CMD ["bash"]
