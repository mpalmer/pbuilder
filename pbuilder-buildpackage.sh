#!/bin/bash
export LANG=C
export LC_ALL=C

PACKAGENAME=$1
. /etc/pbuilderrc
CHROOTEXEC="chroot $BUILDPLACE "

echo cleaning the build env
rm -rf $BUILDPLACE

echo building the build env
mkdir -p $BUILDPLACE
cd $BUILDPLACE
tar xfzp $BASETGZ
mkdir -p $BUILDPLACE/tmp/buildd

echo Installing the build-deps and building
$CHROOTEXEC /bin/sh -c "(cd tmp/buildd; apt-get -y build-dep $PACKAGENAME ; apt-get -y source --build $PACKAGENAME || rm /tmp/buildd/* )"
echo Installing $BUILDPLACE/tmp/buildd/* to archive
mkdir -p $MYREPOSITORYEXTRAPATH
cp $BUILDPLACE/tmp/buildd/* $MYREPOSITORYEXTRAPATH

