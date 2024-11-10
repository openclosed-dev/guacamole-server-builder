#!/bin/bash

set -e

PACKAGE_NAME=guacd_${GUACAMOLE_VERSION}-${GUACAMOLE_REVISION}${OS_CODENAME}_amd64
PACKAGE_DIR=/build/packages/${PACKAGE_NAME}

rm -rf /build/*
rm -f /work/${PACKAGE_NAME}.deb

tar -xzvf /work/guacamole-server-${GUACAMOLE_VERSION}.tar.gz -C /build

cd /build/guacamole-server-${GUACAMOLE_VERSION}

LDFLAGS=-lrt ./configure \
    --prefix=/opt/guacamole \
    --with-systemd-dir=/etc/systemd/system
make
make install

mkdir -p ${PACKAGE_DIR}/{etc/systemd/system,DEBIAN,debian,opt,usr/lib/x86_64-linux-gnu}

sed -e 's/^ExecStart=.*$/\0 -b 0.0.0.0/' \
    -e 's|\[Service\]|\0\nEnvironment=LD_LIBRARY_PATH=/opt/guacamole/lib|' \
    /etc/systemd/system/guacd.service > ${PACKAGE_DIR}/etc/systemd/system/guacd.service
cp -r /opt/guacamole ${PACKAGE_DIR}/opt/
cp -r /usr/lib/x86_64-linux-gnu/freerdp2 ${PACKAGE_DIR}/usr/lib/x86_64-linux-gnu/

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
