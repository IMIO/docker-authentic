FROM plone:4-alpine

ENV PIP=9.0.3 \
    ZC_BUILDOUT=2.13.1 \
    SETUPTOOLS=40.8.0 \
    WHEEL=0.33.1 \
    PLONE_MAJOR=4.3 \
    PLONE_VERSION=4.3.19 \
    PLONE_MD5=04ed5beac7fb8504f06a36d44e407b06

LABEL plone=$PLONE_VERSION \
    os="alpine" \
    os.version="3.10" \
    name="Plone 4.3" \
    description="Plone image, based on Unified Installer" \
    maintainer="Plone Community"

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

HEALTHCHECK --interval=1m --timeout=5s --start-period=1m \
  CMD nc -z -w5 127.0.0.1 8080 || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]

RUN apk add --update --no-cache --virtual .build-deps \
