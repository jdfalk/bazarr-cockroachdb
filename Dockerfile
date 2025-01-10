# # syntax=docker/dockerfile:1

# FROM ghcr.io/linuxserver/unrar:latest AS unrar

# FROM ghcr.io/linuxserver/baseimage-alpine:3.21

# # set version label
# ARG BUILD_DATE
# ARG VERSION
# ARG BAZARR_VERSION
# LABEL build_version="Linuxserver.io version:- ${BAZARR_VERSION} Build-date:- ${BUILD_DATE}"
# LABEL maintainer="chbmb"
# # hard set UTC in case the user does not define it
# ENV TZ="Etc/UTC"
# ENV UV_PROJECT_ENVIRONMENT="/lsiopy"

# RUN \
#   echo "**** install build packages ****" && \
#   apk add --no-cache --virtual=build-dependencies \
#   build-base \
#   cargo \
#   libffi-dev \
#   libpq-dev \
#   libxml2-dev \
#   libxslt-dev \
#   python3-dev && \
#   echo "**** install packages ****" && \
#   apk add --no-cache \
#   ffmpeg \
#   libxml2 \
#   libxslt \
#   mediainfo \
#   python3 \
#   uv
# RUN apk add --update npm

# RUN echo "**** install bazarr ****" && \
#   mkdir -p \
#   /app/bazarr/bin && \
#   if [ -z ${BAZARR_VERSION+x} ]; then \
#   BAZARR_VERSION=$(curl -sX GET "https://api.github.com/repos/jdfalk/bazarr-cockroachdb/releases/latest" \
#   | awk '/tag_name/{print $4;exit}' FS='[""]'); \
#   fi && \
#   echo "Bazarr Version is ${BAZARR_VERSION}" && \
#   printf "Bazarr Version is ${BAZARR_VERSION}"  && \
#   curl -o \
#   /tmp/bazarr.zip -L \
#   "https://github.com/jdfalk/bazarr-cockroachdb/releases/download/${BAZARR_VERSION}/bazarr.zip" && \
#   unzip \
#   /tmp/bazarr.zip -d \
#   /app/bazarr/bin

# RUN rm -Rf /app/bazarr/bin/bin && \
#   echo "UpdateMethod=docker\nBranch=master\nPackageVersion=${BAZARR_VERSION}\nPackageAuthor=linuxserver.io" > /app/bazarr/package_info && \
#   curl -o \
#   /app/bazarr/bin/pyproject.toml -L \
#   https://raw.githubusercontent.com/jdfalk/bazarr-cockroachdb/refs/tags/v1.5.2/pyproject.toml && \
#   cat /app/bazarr/bin/pyproject.toml

# RUN uv venv /lsiopy

# COPY LICENSE /app/bazarr/bin
# COPY README.md /app/bazarr/bin

# # "https://github.com/jdfalk/bazarr-cockroachdb/releases/download/${BAZARR_VERSION}/pyproject.toml" && \
# RUN uv sync \
#   --all-extras \
#   --dev \
#   --directory /app/bazarr/bin \
#   --extra-index-url https://wheel-index.linuxserver.io/alpine-3.21/

# # curl -o \
# #   /app/bazarr/bin/postgres-requirements.txt -L \
# #   "https://raw.githubusercontent.com/morpheus65535/bazarr/${BAZARR_VERSION}/postgres-requirements.txt" && \
# # echo "**** Install requirements ****" && \
# # python3 -m venv /lsiopy && \
# # pip install -U --no-cache-dir \
# #   pip \
# #   wheel && \
# # pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.21/ \
# #   -r /app/bazarr/bin/requirements.txt \
# #   -r /app/bazarr/bin/postgres-requirements.txt && \
# # echo "sqlalchemy-cockroachdb" >> /app/bazarr/bin/requirements.txt && \
# # pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.21/ \
# #   -r /app/bazarr/bin/requirements.txt && \
# RUN  printf "Linuxserver.io version: ${BAZARR_VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
#   echo "**** clean up ****"
# RUN  apk del --purge \
#   build-dependencies
# RUN  rm -rf \
#   $HOME/.cache \
#   $HOME/.cargo \
#   /tmp/*

# # add local files
# COPY root/ /

# # add unrar
# COPY --from=unrar /usr/bin/unrar-alpine /usr/bin/unrar

# # ports and volumes
# EXPOSE 6767

# VOLUME /config


# # RUN sed -i.bak 's/drivername="postgresql"/drivername="cockroachdb"/' /app/bazarr/bin/bazarr/app/database.py && \
# #   sed -i.bak "s/elif bind\.engine\.name == \'postgresql\':/# PostgreSQL detected/g" /app/bazarr/bin/migrations/env.py && \
# #   sed -i.bak 's/bind\.execute(text\(\"SET CONSTRAINTS ALL DEFERRED;\"\))/# Constraints deferred/' /app/bazarr/bin/migrations/env.py && \
# #   sed -i.bak 's/bind\.execute(text\(\"SET CONSTRAINTS ALL IMMEDIATE;\"\))/# Constraints immediate/' /app/bazarr/bin/migrations/env.py


# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/unrar:latest AS unrar

FROM ghcr.io/linuxserver/baseimage-alpine:3.21

# set version label
ARG BUILD_DATE
ARG VERSION
ARG BAZARR_VERSION
LABEL build_version="Linuxserver.io version:- ${BAZARR_VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"
# hard set UTC in case the user does not define it
ENV TZ="Etc/UTC"
ENV UV_PROJECT_ENVIRONMENT="/lsiopy"

RUN \
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
  mediainfo \
  python3 && \
  echo "**** install bazarr ****" && \
  mkdir -p \
  /app/bazarr/bin && \
  if [ -z ${BAZARR_VERSION+x} ]; then \
  BAZARR_VERSION=$(curl -sX GET "https://api.github.com/repos/jdfalk/bazarr-cockroachdb/releases/latest" \
  | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
  /tmp/bazarr.zip -L \
  "https://github.com/jdfalk/bazarr-cockroachdb/releases/download/${BAZARR_VERSION}/bazarr.zip" && \
  unzip \
  /tmp/bazarr.zip -d \
  /app/bazarr/bin && \
  rm -Rf /app/bazarr/bin/bin && \
  echo "UpdateMethod=docker\nBranch=master\nPackageVersion=${BAZARR_VERSION}\nPackageAuthor=linuxserver.io" > /app/bazarr/package_info && \
  curl -o \
  /app/bazarr/bin/postgres-requirements.txt -L \
  "https://raw.githubusercontent.com/morpheus65535/bazarr/master/postgres-requirements.txt" && \
  curl -o \
  /app/bazarr/bin/requirements.txt -L \
  "https://raw.githubusercontent.com/morpheus65535/bazarr/master/requirements.txt" && \
  echo "**** Install requirements ****" && \
  python3 -m venv /lsiopy && \
  pip install -U --no-cache-dir \
  pip \
  wheel && \
  echo "sqlalchemy-cockroachdb" >> /app/bazarr/bin/requirements.txt && \
  # echo "requests" >> /app/bazarr/bin/requirements.txt && \
  # echo "semver" >> /app/bazarr/bin/requirements.txt && \
  # echo "pretty" >> /app/bazarr/bin/requirements.txt && \
  # echo "pytz" >> /app/bazarr/bin/requirements.txt && \
  # # echo "subliminal_patch" >> /app/bazarr/bin/requirements.txt && \
  # # echo "subliminal_patch.core" >> /app/bazarr/bin/requirements.txt && \
  # # echo "subliminal_patch.exceptions" >> /app/bazarr/bin/requirements.txt && \
  # # echo "subliminal_patch.extensions" >> /app/bazarr/bin/requirements.txt && \
  # echo "pytz_deprecation_shim" >> /app/bazarr/bin/requirements.txt && \
  # echo "apprise" >> /app/bazarr/bin/requirements.txt && \
  # echo "apscheduler" >> /app/bazarr/bin/requirements.txt && \
  # echo "tzlocal" >> /app/bazarr/bin/requirements.txt && \
  # echo "dynaconf" >> /app/bazarr/bin/requirements.txt && \
  # echo "flask_restx" >> /app/bazarr/bin/requirements.txt && \
  # echo "unidecode" >> /app/bazarr/bin/requirements.txt && \
  # echo "textdistance" >> /app/bazarr/bin/requirements.txt && \
  # echo "subzero.language" >> /app/bazarr/bin/requirements.txt && \
  # echo "waitress.server" >> /app/bazarr/bin/requirements.txt && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.21/ \
  -r /app/bazarr/bin/requirements.txt \
  -r /app/bazarr/bin/postgres-requirements.txt && \
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


# RUN sed -i.bak 's/drivername="postgresql"/drivername="cockroachdb"/' /app/bazarr/bin/bazarr/app/database.py && \
#   sed -i.bak "s/elif bind\.engine\.name == \'postgresql\':/# PostgreSQL detected/g" /app/bazarr/bin/migrations/env.py && \
#   sed -i.bak 's/bind\.execute(text\(\"SET CONSTRAINTS ALL DEFERRED;\"\))/# Constraints deferred/' /app/bazarr/bin/migrations/env.py && \
#   sed -i.bak 's/bind\.execute(text\(\"SET CONSTRAINTS ALL IMMEDIATE;\"\))/# Constraints immediate/' /app/bazarr/bin/migrations/env.py

