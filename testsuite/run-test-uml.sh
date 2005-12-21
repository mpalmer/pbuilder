#!/bin/sh
# This is a testsuite.
# estimated run-time on my PC; 45 minutes.

PBUILDER_UML=/usr/bin/pbuilder-user-mode-linux

RESULTFILE="run-test-uml.log"
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


sudo ifconfig eth0:tst 192.168.30.62 netmask 255.255.255.0
tcpproxy 8081 ring.asahi-net.or.jp 80 &
TCPPROXY=$!

pbuilder-user-mode-linux test --configfile non-existing-configfile

if [ -x "${PBUILDER_UML}" ]; then
    for distribution in sid sarge; do
	pbuilder-user-mode-linux create --mirror  http://192.168.30.198/archives/linux/debian/debian --distribution "${distribution}" --uml-image $(pwd)/testimage --logfile uml/pbuilder-user-mode-linux-create-${distribution}.log
	log_success create-${distribution}

	for PKG in dsh; do 
	    ( 
		mkdir testbuild
		cd testbuild
		apt-get source -d ${PKG}
	    )
	    pbuilder-user-mode-linux build --uml-image $(pwd)/testimage --buildplace $(pwd)/testbuild/ --logfile uml/pbuilder-user-mode-linux-build-${PKG}-${distribution}.log testbuild/${PKG}*.dsc
	    log_success build-${distribution}-${PKG}

	    (
		mkdir testbuild2
		cd testbuild2
		apt-get source ${PKG}
		cd ${PKG}-*
		pdebuild-user-mode-linux --logfile ../../uml/pdebuild-user-mode-linux-normal-${distribution}.log -- --uml-image $(pwd)/../../testimage --buildplace $(pwd)/../../testbuild2/
		log_success pdebuild-${distribution}-${PKG}

		pdebuild-user-mode-linux --use-pdebuild-internal --logfile ../../uml/pdebuild-user-mode-linux-internal-${distribution}.log -- --uml-image $(pwd)/../../testimage --buildplace $(pwd)/../../testbuild2/
		log_success pdebuild-internal-${distribution}-${PKG}
	    )
	done
	pbuilder-user-mode-linux execute --uml-image $(pwd)/testimage --logfile uml/pbuilder-user-mode-linux-execute-${distribution}.log ../examples/execute_paramtest.sh test1 test2 test3
	log_success execute-${distribution}

	rm -rf testbuild testbuild2 testimage
    done
fi

kill ${TCPPROXY}

echo '### RESULT: ###'
cat "${RESULTFILE}"
