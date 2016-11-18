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
# Build mesos:
#------------------------------------------------------------------------------

RUN apt-get update && DEV='git openjdk-7-jdk autoconf libtool build-essential \
    python-dev libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev \
    libsvn-dev' && DEBIAN_FRONTEND=noninteractive apt-get install -y ${DEV}

RUN git clone https://git-wip-us.apache.org/repos/asf/mesos.git && cd mesos \
    && { [ "${TAG}" != "master" ] && git checkout tags/${TAG} -b build; }; \
    ./bootstrap && mkdir build && cd build && ../configure --prefix=${PREFIX} \
    --disable-dependency-tracking --disable-maintainer-mode --disable-python \
    --enable-optimize --enable-silent-rules --sbindir=${PREFIX}/bin

RUN cd mesos/build && CORES=$(cat /proc/cpuinfo | grep processor | wc -l) \
    && make -j${CORES} && make install

#------------------------------------------------------------------------------
# Isolate mesos:
#------------------------------------------------------------------------------

COPY ubuntu/rootfs /

RUN find ${PREFIX} -name *.sh -delete -o -name *.la -delete \
    && find ${PREFIX}/lib -type l -delete && bash -c "rm -rf /mesos \
    ${PREFIX}/{include,etc} ${PREFIX}/lib/{mesos,pkgconfig}" \
    && isolate-mesos

#------------------------------------------------------------------------------
# Clean image (for latter squash):
#------------------------------------------------------------------------------

RUN find ${PREFIX} -type f -executable | xargs strip -s &> /dev/null; \
    DEV='git openjdk-7-jdk autoconf libtool build-essential python-dev \
    libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev \
    libsvn-dev' && DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge \
    -y ${DEV} && apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

#------------------------------------------------------------------------------
# Command:
#------------------------------------------------------------------------------

CMD ["/bin/bash"]
