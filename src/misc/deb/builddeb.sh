#!/bin/sh

# building debian/ubuntu package for itexmacs

./configure --prefix=$HOME/itmroot/usr/local
make
make install
mkdir ~/itmroot/usr/local/share/applications
cp -f TeXmacs/misc/mime/itexmacs.desktop ~/itmroot/usr/local/share/applications
mkdir ~/itmroot/DEBIAN
cp -f misc/deb/DEBIAN/control ~/itmroot/DEBIAN
dpkg -b ~/itmroot itexmacs.deb

