#!/bin/sh
# This is a testsuite.
# estimated run-time on my PC; 11 minutes.

PBUILDER=/usr/sbin/pbuilder

RESULTFILE="run-test.log"
: > ${RESULTFILE}
RESULTFILE=$(readlink -f ${RESULTFILE})

log_success () {
    CODE=$?
    if [ $CODE = 0 ]; then
	echo "[OK]   $1" >> ${RESULTFILE}
    else
	echo "[FAIL] $1" >> ${RESULTFILE}
    fi
}

vmstat -n 1 > normal/vmstat &
VMSTATPID=$!
LC_ALL=C iostat -dxt hda 1 > normal/iostat & 
IOSTATPID=$!

if [ -x "${PBUILDER}" ]; then
    for distribution in sid sarge; do
	sudo ${PBUILDER} create --mirror http://ring.asahi-net.or.jp/archives/linux/debian/debian --distribution "${distribution}" --basetgz $(pwd)/testimage --logfile normal/pbuilder-create-${distribution}.log 
# --hookdir /usr/share/doc/pbuilder/examples/libc6workaround
	log_success create-${distribution}

	for PKG in dsh; do 
	    ( 
		mkdir testbuild
		cd testbuild
		apt-get source -d ${PKG}
	    )
	    sudo ${PBUILDER} build --basetgz $(pwd)/testimage --buildplace $(pwd)/testbuild/ --logfile normal/pbuilder-build-${PKG}-${distribution}.log testbuild/${PKG}*.dsc
	    log_success build-${distribution}-${PKG}

	    (
		mkdir testbuild2
		cd testbuild2
		apt-get source ${PKG}
		cd ${PKG}-*
		pdebuild --logfile ../../normal/pdebuild-normal-${distribution}.log -- --basetgz $(pwd)/../../testimage --buildplace $(pwd)/../../testbuild2/
		log_success pdebuild-${distribution}-${PKG}

		pdebuild --use-pdebuild-internal --logfile ../../normal/pdebuild-internal-${distribution}.log -- --basetgz $(pwd)/../../testimage --buildplace $(pwd)/../../testbuild2/
		log_success pdebuild-internal-${distribution}-${PKG}

	    )
	done
	sudo ${PBUILDER} execute --basetgz $(pwd)/testimage --logfile normal/pbuilder-execute-${distribution}.log ../examples/execute_paramtest.sh test1 test2 test3
	log_success execute-${distribution}

	sudo rm -rf testbuild testbuild2 testimage
    done
fi

kill $VMSTATPID
kill $IOSTATPID
