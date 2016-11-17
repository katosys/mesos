#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM ubuntu:14.04
MAINTAINER Marc Villacorta Morera <marc.villacorta@gmail.com>

#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

ENV TAG="1.1.0" \
    PREFIX="/opt/mesos"

#------------------------------------------------------------------------------
# Populate the root file system:
#------------------------------------------------------------------------------

COPY ubuntu/rootfs /

#------------------------------------------------------------------------------
# Build mesos:
#------------------------------------------------------------------------------

RUN apt-get update && DEV='git openjdk-7-jdk autoconf libtool build-essential \
    python-dev libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev \
    libsvn-dev' && DEBIAN_FRONTEND=noninteractive apt-get install -y $DEV \
    && git clone https://git-wip-us.apache.org/repos/asf/mesos.git && cd mesos \
    && { [ "${TAG}" != "master" ] && git checkout tags/${TAG} -b build; }; \
    ./bootstrap && mkdir build && cd build && ../configure --prefix=${PREFIX} \
    --disable-dependency-tracking --disable-maintainer-mode --disable-python \
    --enable-optimize --enable-silent-rules --sbindir=${PREFIX}/bin \
    && CORES=$(cat /proc/cpuinfo | grep processor | wc -l) && make -j${CORES} \
    && make install && cd / && rm -rf mesos ${PREFIX}/{include,etc} \
    && find ${PREFIX} -type f -perm /u=x,g=x,o=x | xargs strip -s 2>/dev/null

#------------------------------------------------------------------------------
# Command:
#------------------------------------------------------------------------------

CMD ["/bin/bash"]
