FROM python:2.7-alpine

LABEL maintainer="quasitiger@gmail.com"
LABEL description="Alpine-based Volatility 2 forensic container with yara, plugins, and sandboxed user"

ARG GIT_TAG_VOLATILITY=2.6.1
ARG GIT_TAG_VOLATILITY_COMMUNITY=master
ARG INSTALL_GROUP=ci
ARG INSTALL_USER=unprivileged
ARG INSTALL_PREFIX=/usr/local
ARG PRODUCT_AUTHOR=quasitiger
ARG PRODUCT_REPOSITORY=https://github.com/quasitiger/volatility2-docker.git
ARG PRODUCT_BUILD_COMMIT=manual
ARG PRODUCT_BUILD_DATE=2025-04-13

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PYTHONFAULTHANDLER=1
ENV PYTHONHASHSEED=random
ENV PYTHONUNBUFFERED=1
ENV PATH=/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin
ENV YARA_VERSION=v3.11.0

# Create group and user
RUN addgroup -S "$INSTALL_GROUP" \
 && adduser -DG -S "$INSTALL_USER" -G "$INSTALL_GROUP" -g "Unprivileged user,,,,"

# Base system packages
RUN apk add --no-cache \
    bash bison ca-certificates flex less libxml2 libxslt python2 zlib file util-linux dumb-init

# Build dependencies
RUN apk add --no-cache --virtual=stage \
    g++ gcc git jpeg-dev libxml2-dev libxslt-dev linux-headers musl-dev openssl-dev \
    python2-dev swig libffi-dev

# Python setup
RUN python2 -m ensurepip --default-pip \
 && pip2 install --no-cache --upgrade wheel setuptools \
 && pip2 install --no-cache \
    distorm3 lxml openpyxl pefile pillow==6 pycoin pycrypto ujson \
    colorama construct==2.5.3 haystack pysocks pysphere requests simplejson

# Install yara-python manually from staged path if present
COPY --chown=unprivileged:ci ./yara-python /usr/local/lib/yara-python
WORKDIR /usr/local/lib/yara-python
RUN python setup.py install

RUN find . -type d -exec chmod 0755 "{}" \; \
 && find . -type f -exec chmod 0644 "{}" \;

# Install Volatility
WORKDIR /usr/local/lib
RUN git clone --branch="$GIT_TAG_VOLATILITY" --depth=1 --single-branch \
    https://github.com/volatilityfoundation/volatility.git
WORKDIR /usr/local/lib/volatility
RUN python2 setup.py install \
 && chmod 0755 vol.py \
 && for destination in v2 vol vol2 volatility volatility2; do \
      ln -sf "/usr/local/lib/volatility/vol.py" "/usr/local/bin/$destination"; \
    done

# Install plugins
WORKDIR /usr/local/share/volatility/plugins
RUN git clone --branch="$GIT_TAG_VOLATILITY_COMMUNITY" --depth=1 --single-branch \
    https://github.com/volatilityfoundation/community.git

# Cleanup
RUN apk del --purge stage

# Optional profile aliases (if any)
COPY --chown=root:root assets/aliases.sh /etc/profile.d/

# Default execution settings
#WORKDIR /usr/local
WORKDIR /
USER unprivileged
#ENTRYPOINT ["/usr/bin/dumb-init", "--", "volatility"]
#CMD ["--help"]

# Metadata
LABEL image.author="$PRODUCT_AUTHOR"
LABEL image.commit="$PRODUCT_BUILD_COMMIT"
LABEL image.date="$PRODUCT_BUILD_DATE"
LABEL image.repository="$PRODUCT_REPOSITORY"

#VOLUME ["/tmp", "/var/tmp"]
