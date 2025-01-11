# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/unrar:latest AS unrar

FROM ghcr.io/linuxserver/baseimage-alpine:3.21

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BAZARR_VERSION
ARG BAZARR_BUILD_INFO
LABEL build_version="Linuxserver.io version:- ${BAZARR_VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"
# hard set UTC in case the user does not define it
ENV TZ="Etc/UTC"
ENV UV_PROJECT_ENVIRONMENT="/lsiopy"

RUN \
  echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  cat /etc/apk/repositories && \
  apk update

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
  build-base \
  cargo \
  libffi-dev \
  libpq-dev \
  libxml2-dev \
  libxslt-dev \
  python3-dev
RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
  ffmpeg \
  libxml2 \
  libxslt \
  mediainfo \
  python3 && \
  uv@testing
RUN \
  echo "**** install nodejs ****" && \
  apk add --no-cache \
  nodejs \
  npm
RUN \
  echo "**** install bazarr ****" && \
  mkdir -p \
  /app/bazarr/bin
COPY dist/*.tar.gz ./
RUN ls && \
  tar -xf \
  ${BAZARR_BUILD_INFO} -C \
  /app/bazarr/bin && \
  echo "UpdateMethod=docker\nBranch=master\nPackageVersion=${BAZARR_VERSION}\nPackageAuthor=linuxserver.io" > /app/bazarr/package_info && \
  printf "Linuxserver.io version: ${BAZARR_VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** clean up ****" && \
  apk del --purge \
  build-dependencies && \
  rm -rf \
  $HOME/.cache \
  $HOME/.cargo \
  /tmp/*

# add local files
COPY root/ /

# add unrar
COPY --from=unrar /usr/bin/unrar-alpine /usr/bin/unrar

# ports and volumes
EXPOSE 6767

VOLUME /config

