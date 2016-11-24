#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM gentoo/stage3-amd64
MAINTAINER Marc Villacorta Morera <marc.villacorta@gmail.com>

#------------------------------------------------------------------------------
# Build mesos:
#------------------------------------------------------------------------------

ENV VERSION="1.1.0"

COPY gentoo/rootfs /

RUN emerge-webrsync -q \
    && cd /usr/local/portage/sys-cluster/mesos \
    && mv mesos.ebuild mesos-${VERSION}.ebuild \
    && ebuild mesos-${VERSION}.ebuild digest

RUN emerge -q --onlydeps sys-cluster/mesos
RUN emerge sys-cluster/mesos

#------------------------------------------------------------------------------
# Isolate mesos in /opt:
#------------------------------------------------------------------------------

RUN find /opt -name *.sh -delete -o -name *.la -delete \
    && rm -rf /opt/{include,etc} /opt/lib/pkgconfig \
    && isolate-mesos

#------------------------------------------------------------------------------
# Pre-squash cleanup:
#------------------------------------------------------------------------------

RUN wget https://busybox.net/downloads/binaries/busybox-x86_64 -qO /busybox \
    && chmod +x /busybox && busybox rm -rf var/ usr/ tmp/ sbin/ root/ mnt/ \
    lib* media/ home/ boot/ run/ /etc bin/* &> /dev/null; \
    /busybox ln -s /busybox /bin/sh \
    && /busybox ln -s /busybox /bin/ls \
    && /busybox ln -s /busybox /bin/cp

#------------------------------------------------------------------------------
# Command:
#------------------------------------------------------------------------------

CMD ["/bin/sh"]
