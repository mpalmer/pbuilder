#! /bin/bash
export LANG=C
export LC_ALL=C

function copydsc () {
    local DSCFILE=$1
    local TARGET=$2
    cp $(echo $DSCFILE | sed 's/^\(.*\)\.dsc$/\1/' ).diff.gz \
    $(echo $DSCFILE | sed 's/^\(.*\)\.dsc$/\1/').tar.gz \
    $(echo $DSCFILE | sed 's/\(.*\)-[^-.]*\.dsc$/\1/').orig.tar.gz \
    $TARGET
}

function checkbuilddep () {
    (
    cd $BUILDPLACE/tmp/buildd/*/
    $CHROOTEXEC usr/bin/apt-get -y install $(dpkg-checkbuilddeps 2>&1 | sed 's/^.*: \(.*\)$/\1/' | awk 'BEGIN{RS=", "} /^([^([]*)/{print $1}')
    )
}

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
echo Copying source file
copydsc $PACKAGENAME $BUILDPLACE/tmp/buildd
echo Extracting source
$CHROOTEXEC /usr/bin/dpkg-source -x $(basename $PACKAGENAME)
echo Installing the build-deps 
checkbuilddep
echo Building the package
$CHROOTEXEC /bin/sh -c "(cd tmp/buildd/*/; dpkg-buildpackage)"
echo Installing $BUILDPLACE/tmp/buildd/* to archive
mkdir -p $MYREPOSITORYEXTRAPATH
cp $BUILDPLACE/tmp/buildd/* $MYREPOSITORYEXTRAPATH

