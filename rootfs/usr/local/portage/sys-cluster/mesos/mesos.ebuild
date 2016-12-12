# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Apache Mesos abstracts CPU, memory, storage, and other compute resources away from machines."
HOMEPAGE="http://mesos.apache.org/"
EGIT_REPO_URI="https://github.com/apache/mesos.git"
EGIT_COMMIT="${PV}"
RESTRICT="mirror"
LICENSE="Apache-2.0"
KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SLOT="0"

DEPEND="dev-libs/apr
        dev-vcs/subversion
        dev-libs/cyrus-sasl
        dev-java/maven-bin
        net-misc/curl
        virtual/jdk"

src_prepare() {
  ./bootstrap
  mkdir build
}

src_configure() {
  cd build
  ../configure \
    --prefix=/opt \
    --sbindir=/opt/bin \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    --enable-silent-rules \
    --disable-python
}

src_compile() {
  cd build
  make -j2
}

src_install() {
  cd build
  emake DESTDIR="${D}" install
}
