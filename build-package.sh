#!/bin/bash
export LANG=C
export LC_ALL=C

PACKAGENAME=$1
BASETGZ=/tmp/base.tgz
MYREPOSITORY=/home/dancer/DEBIAN/personal-buildd/build-package/my-repos
MYREPOSITORYEXTRAPATH=$MYREPOSITORY/i386/athlon
MYREPOSITORYHTTP=http://atoron.work.isl.doshisha.ac.jp/athlonmirror
EXTRAPACKAGES=gcc3.0-athlon-builder
export DEBIAN_BUILDARCH=athlon
BUILDPLACE=/home/dancer/buildd/tmp/buildd
CHROOTEXEC="chroot $BUILDPLACE "



cd $MYREPOSITORY
echo Initializing repository
dpkg-scanpackages . . | gzip > Packages.gz
dpkg-scansources . . | gzip > Sources.gz


echo cleaning the build env
rm -rf $BUILDPLACE

echo building the build env
mkdir -p $BUILDPLACE
cd $BUILDPLACE
tar xfzp $BASETGZ
mkdir -p $BUILDPLACE/tmp/buildd
for a in passwd hosts hostname resolv.conf; do 
  cp /etc/$a $BUILDPLACE/etc/$a;
done

echo Installing apt-lines
cat > $BUILDPLACE/etc/apt/sources.list << EOF
deb $MYREPOSITORYHTTP ./
deb-src $MYREPOSITORYHTTP ./
deb http://www.jp.debian.org/debian unstable main contrib non-free
deb-src http://www.jp.debian.org/debian unstable main contrib non-free
EOF

echo Refreshing the base.tgz 
$CHROOTEXEC /usr/bin/apt-get update
$CHROOTEXEC /usr/bin/dpkg --purge lilo
$CHROOTEXEC /usr/bin/apt-get -y dist-upgrade
$CHROOTEXEC /usr/bin/apt-get -y install build-essential dpkg-dev apt $EXTRAPACKAGES
$CHROOTEXEC /usr/bin/apt-get clean
cd $BUILDPLACE
#tar cfz $BASETGZ *

echo Installing the build-deps and building
$CHROOTEXEC /bin/sh -c "(cd tmp/buildd; apt-get -y build-dep $PACKAGENAME ; apt-get -y source --build $PACKAGENAME || rm /tmp/buildd/* )"
echo Installing $BUILDPLACE/tmp/buildd/* to archive
mkdir -p $MYREPOSITORYEXTRAPATH
cp $BUILDPLACE/tmp/buildd/* $MYREPOSITORYEXTRAPATH
