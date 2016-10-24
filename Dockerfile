#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM alpine:3.4
MAINTAINER Marc Villacorta Morera <marc.villacorta@gmail.com>

#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

ENV TAG="1.0.1" \
    PREFIX="/usr/local" \
    JAVA_HOME="/usr/lib/jvm/default-jvm" \
    EDGE_REPO="http://nl.alpinelinux.org/alpine/edge/community"

#------------------------------------------------------------------------------
# Install mesos:
#------------------------------------------------------------------------------

COPY libtool /tmp

RUN apk add -U --no-cache -t dev git autoconf automake libtool g++ \
    zlib-dev fts-dev apr-dev curl-dev file cyrus-sasl-dev cyrus-sasl-crammd5 \
    subversion-dev make patch linux-headers binutils openjdk8 \
    && apk add -U --no-cache -t dev maven --repository ${EDGE_REPO} \
    && apk add -U --no-cache libstdc++ libgcc subversion-libs libcurl fts zlib \
    && git clone https://git-wip-us.apache.org/repos/asf/mesos.git && cd mesos \
    && { [ "${TAG}" != "master" ] && git checkout tags/${TAG} -b ${TAG}; }; \
    ./bootstrap && mkdir build && cd build && ../configure --prefix=${PREFIX} \
    --disable-dependency-tracking --disable-maintainer-mode --disable-python \
    --enable-optimize --enable-silent-rules --disable-static --disable-shared \
    && mv /tmp/libtool . && CORES=$(cat /proc/cpuinfo | grep processor | wc -l) \
    && make -j${CORES} && make install && cd && rm -rf /mesos ${PREFIX}/include \
    && find ${PREFIX} -type f -perm /u=x,g=x,o=x | xargs strip -s 2>/dev/null; \
    apk del --purge dev && rm -rf /var/cache/apk/*

#------------------------------------------------------------------------------
# Command:
#------------------------------------------------------------------------------

CMD ["/bin/sh"]
