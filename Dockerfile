FROM debian:12-slim

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
  rm -f /etc/apt/apt.conf.d/docker-clean \
  && apt-get update \
  && apt-get install -y libglib2.0-dev libgtk-3-dev libhandy-1-dev \
                        meson valac \
                        gettext desktop-file-utils \
                        libsystemd-dev

RUN mkdir -p /usr/src/snapshot-explorer
COPY . /usr/src/snapshot-explorer

# --prefer-static --default-library=static \
RUN cd /usr/src/snapshot-explorer \
  && meson build --prefix=/usr/local -Denable-nautilus-extension=false \
  && cd build \
  && ninja \
  && ninja install


FROM debian:12-slim

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
  rm -f /etc/apt/apt.conf.d/docker-clean \
  && apt-get update \
  && apt-get install -y ca-certificates \
  && echo 'deb https://deb.debian.org/debian bookworm-backports main contrib' >> /etc/apt/sources.list.d/backports.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
                     libgtk-3-0 libhandy-1-0 zfsutils-linux

COPY --from=0 /usr/local/bin/snapshot-explorer /usr/local/bin/snapshot-explorer

CMD ["/usr/local/bin/snapshot-explorer"]