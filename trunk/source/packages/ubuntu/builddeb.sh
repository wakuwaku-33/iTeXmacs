#!/bin/sh

# building debian/ubuntu package for itexmacs

if [ ! -f configure ]
then
  exit
fi

SRCPATH=$PWD
cd ..
DISTPATH=$PWD/distr
#echo $DISTPATH
cd $SRCPATH

rm -rf $DISTPATH/*

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
cp -p -f packages/ubuntu/DEBIAN/* $DISTPATH/DEBIAN
dpkg -b $DISTPATH iTeXmacs.deb

