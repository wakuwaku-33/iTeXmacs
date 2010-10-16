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
./configure --enable-qt
make -r
make -e prefix=$DISTPATH/usr/local install

mkdir -p $DISTPATH/usr/local/share/applications
cp -f TeXmacs/misc/mime/itexmacs.desktop $DISTPATH/usr/local/share/applications

rm -rf $DISTPATH/usr/local/share/iTeXmacs/.svn
rm -rf $DISTPATH/usr/local/share/iTeXmacs/*/.svn
rm -rf $DISTPATH/usr/local/share/iTeXmacs/*/*/.svn
rm -rf $DISTPATH/usr/local/share/iTeXmacs/*/*/*/.svn
rm -rf $DISTPATH/usr/local/share/iTeXmacs/*/*/*/*/.svn
rm -rf $DISTPATH/usr/local/share/iTeXmacs/*/*/*/*/*/.svn
rm -rf $DISTPATH/usr/local/share/iTeXmacs/*/*/*/*/*/*/.svn
rm -rf $DISTPATH/usr/local/share/iTeXmacs/*/*/*/*/*/*/*/.svn

mkdir -p $DISTPATH/DEBIAN
cp -f misc/deb/DEBIAN/control $DISTPATH/DEBIAN
dpkg -b $DISTPATH iTeXmacs.deb

