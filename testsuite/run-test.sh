#!/bin/sh
# This is a testsuite.
# estimated run-time on my PC; ?? minutes.

PBUILDER=/usr/sbin/pbuilder

vmstat -n 1 > vmstat &
VMSTATPID=$!
LC_ALL=C iostat -dxt hda > iostat & 
IOSTATPID=$!

if [ -x "${PBUILDER}" ]; then
    for distribution in sid sarge; do
	sudo ${PBUILDER} create --mirror http://ring.asahi-net.or.jp/archives/linux/debian/debian --distribution "${distribution}" --basetgz $(pwd)/testimage --logfile pbuilder-create-${distribution}.log 

	for PKG in dsh; do 
	    ( 
		mkdir testbuild
		cd testbuild
		apt-get source -d ${PKG}
	    )
	    sudo ${PBUILDER} build --basetgz $(pwd)/testimage --buildplace $(pwd)/testbuild/ --logfile pbuilder-build-${PKG}-${distribution}.log testbuild/${PKG}*.dsc
	    (
		mkdir testbuild2
		cd testbuild2
		apt-get source ${PKG}
		cd ${PKG}-*
		pdebuild --logfile ../../pdebuild-normal-${distribution}.log -- --basetgz $(pwd)/../../testimage --buildplace $(pwd)/../../testbuild2/
		pdebuild --use-pdebuild-internal --logfile ../../pdebuild-internal-${distribution}.log -- --basetgz $(pwd)/../../testimage --buildplace $(pwd)/../../testbuild2/
	    )
	done
	sudo ${PBUILDER} execute --basetgz $(pwd)/testimage --logfile pbuilder-execute-${distribution}.log ../examples/execute_paramtest.sh test1 test2 test3
	sudo rm -rf testbuild testbuild2 testimage
    done
fi

kill $VMSTATPID
kill $IOSTATPID
