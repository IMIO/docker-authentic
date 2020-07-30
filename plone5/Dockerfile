FROM plone:5-alpine

ENV PIP=19.3.1 \
    ZC_BUILDOUT=2.13.2 \
    SETUPTOOLS=45.0.0 \
    WHEEL=0.33.6 \
    PLONE_MAJOR=5.2 \
    PLONE_VERSION=5.2.1 \
    PLONE_MD5=42407c0313791d3626dc86e674684efe

LABEL plone=$PLONE_VERSION \
    os="alpine" \
    os.version="3.11" \
    name="Plone 5.2" \
    description="Plone image, based on offical image" \
    maintainer="iMio"

COPY buildout.cfg /plone/instance/

RUN apk add --no-cache --virtual .build-deps \
    gcc \
    libc-dev \
    libffi-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libxslt-dev \
    openssl-dev \
    pcre-dev \
    zlib-dev \
 && cd /plone/instance \
 && buildout plonesite:enabled=false\
 && rm -rf bin/buildout \
 && ln -s /data/filestorage/ /plone/instance/var/filestorage \
 && ln -s /data/blobstorage /plone/instance/var/blobstorage \
 && find /data  -not -user plone -exec chown plone:plone {} \+ \
 && find /plone -not -user plone -exec chown plone:plone {} \+ \
 && apk del .build-deps

WORKDIR /plone/instance

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s \
  CMD nc -z -w5 127.0.0.1 8080 || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
