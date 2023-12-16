#!/bin/bash

PACKAGE_NAME=guacd_${GUACAMOLE_VERSION}-${GUACAMOLE_REVISION}_amd64
PACKAGE_DIR=/build/packages/${PACKAGE_NAME}

rm -rf /build/*
rm /work/*.deb

tar -xzvf /work/guacamole-server-${GUACAMOLE_VERSION}.tar.gz -C /build

cd /build/guacamole-server-${GUACAMOLE_VERSION}

LDFLAGS=-lrt ./configure \
    --prefix=/opt/guacamole \
    --with-systemd-dir=/etc/systemd/system
make
make install

mkdir -p ${PACKAGE_DIR}/{etc/systemd/system,DEBIAN,debian,opt}

cp /etc/systemd/system/guacd.service ${PACKAGE_DIR}/etc/systemd/system/
cp -r /opt/guacamole ${PACKAGE_DIR}/opt/

cat <<EOT > ${PACKAGE_DIR}/DEBIAN/control
Package: guacd
Version: ${GUACAMOLE_VERSION}
Architecture: amd64
Maintainer: ${MAINTAINER}
Description: HTML5 web application for accessing remote desktops (proxy daemon)
EOT

cd ${PACKAGE_DIR}
touch debian/control
dpkg-shlibdeps --ignore-missing-info -O../dependencies /opt/guacamole/sbin/guacd /opt/guacamole/lib/*.so
rm debian/control
sed 's/shlibs:Depends=/Depends: /' ../dependencies >> DEBIAN/control

cd /build/packages
dpkg-deb --build --root-owner-group ${PACKAGE_NAME}

cp /build/packages/*.deb /work/
