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

COPY dist/* ./

RUN \
  echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  cat /etc/apk/repositories && \
  apk update && \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
  build-base \
  cargo \
  libffi-dev \
  libpq-dev \
  libxml2-dev \
  libxslt-dev \
  python3-dev && \
  echo "**** install packages ****" && \
  apk add --no-cache \
  ffmpeg \
  libxml2 \
  libxslt \
  mediainfo && \
  # python3 && \
  apk add --no-cache uv@testing && \
  echo "**** install nodejs ****" && \
  apk add --no-cache \
  nodejs \
  npm && \
  echo "**** install bazarr ****" && \
  mkdir -p /app/bazarr/bin && \
  rm -rf /var/cache/apk/* && \
  export BAZARR_BUILD_INFO=$(ls *.tar.gz) && \
  export BAZARR_VERSION=$(ls *.tar.gz | cut -d'-' -f2 | cut -d'.' -f1-3) && \
  echo "Bazarr version is ${BAZARR_VERSION}" && \
  echo "Bazarr build info is ${BAZARR_BUILD_INFO}" && \
  tar -xf \
  $(ls *.tar.gz) -C \
  /app/bazarr/bin && \
  echo "**** rsync bazarr ****" && \
  rsync -az --remove-source-files /app/bazarr/bin/bazarr-${BAZARR_VERSION}/ /app/bazarr/bin/ && \
  echo "**** rmdir old bazarr folder ****" && \
  rm -rf /app/bazarr/bin/bazarr-${BAZARR_VERSION} && \
  uv python -n install python3.10 && \
  echo "UpdateMethod=docker\nBranch=master\nPackageVersion=${BAZARR_VERSION}\nPackageAuthor=linuxserver.io" > /app/bazarr/package_info && \
  printf "Linuxserver.io version: ${BAZARR_VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** clean up ****" && \
  apk del --purge \
  build-dependencies && \
  apk cache clean && \
  rm -rf \
  $HOME/.cache \
  $HOME/.cargo \
  /tmp/* \
  /var/cache/apk/* 

# add local files
COPY root/ /

# add unrar
COPY --from=unrar /usr/bin/unrar-alpine /usr/bin/unrar

# ports and volumes
EXPOSE 6767

VOLUME /config

