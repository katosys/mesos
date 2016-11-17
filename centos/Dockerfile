#------------------------------------------------------------------------------
# Set the base image for subsequent instructions:
#------------------------------------------------------------------------------

FROM centos:7
MAINTAINER Marc Villacorta Morera <marc.villacorta@gmail.com>

#------------------------------------------------------------------------------
# Environment variables:
#------------------------------------------------------------------------------

ENV VERSION="1.1.0" \
    REPO="http://repos.mesosphere.io/el/7/noarch/RPMS"

#------------------------------------------------------------------------------
# Populate the root file system:
#------------------------------------------------------------------------------

COPY centos/rootfs /

#------------------------------------------------------------------------------
# Isolate mesos:
#------------------------------------------------------------------------------

RUN rpm --import http://repos.mesosphere.io/el/RPM-GPG-KEY-mesosphere \
    && rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 \
    && rpm -i ${REPO}/mesosphere-el-repo-7-1.noarch.rpm \
    && yum install -y deltarpm file && yum update -y \
    && yum install --enablerepo=mesosphere-unstable -y mesos-${VERSION} \
    && isolate-mesos && yum autoremove -y mesos-${VERSION} \
    && yum clean all && rm -rf /var/{cache,lib,log}/{yum*,rpm*} \
    && rm -rf /usr/{share,lib,include}/mesos

#------------------------------------------------------------------------------
# For single-layer squashed-images:
#------------------------------------------------------------------------------

# RUN yum autoremove -y && yum clean all \
#    && rm -rf /var/{cache,lib,log}/{yum*,rpm*} /usr/{games,include,share,src} \
#    && rm -rf /usr/{etc,local,libexec} && rm -rf /anaconda-post.log \
#    && rm -rf /var/{cache,db,kerberos,log,spool} && rm -f /usr/bin/{db*,yum*,sys*}

#------------------------------------------------------------------------------
# Command:
#------------------------------------------------------------------------------

CMD ["/bin/sh"]
