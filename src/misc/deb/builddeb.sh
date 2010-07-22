#!/bin/sh

# building debian/ubuntu package for itexmacs

if [ ! -f configure ]
then
  exit
fi

cd ..
DISTPATH=$PWD/distr
#echo $DISTPATH
cd src

#make distclean
./configure --enable-qt --prefix=$DISTPATH
make
make install
mkdir -p $DISTPATH/usr/local/share/applications
cp -f TeXmacs/misc/mime/itexmacs.desktop $DISTPATH/usr/local/share/applications
mkdir -p $DISTPATH/DEBIAN
cp -f misc/deb/DEBIAN/control $DISTPATH/DEBIAN
dpkg -b $DISTPATH itexmacs.deb

