#!/bin/sh
# This is a testsuite.
PBUILDER_UML=/usr/bin/pbuilder-user-mode-linux

if [ -x "${PBUILDER_UML}" ]; then
    for distribution in sid sarge; do
	pbuilder-user-mode-linux create --mirror  http://ring.asahi-net.or.jp/archives/linux/debian/debian --distribution "${distribution}" --uml-image $(pwd)/testimage --logfile pbuilder-user-mode-linux-create-${distribution}.log
	( 
	    mkdir testbuild
	    cd testbuild
	    apt-get source -d dsh
	)
	pbuilder-user-mode-linux build --uml-image $(pwd)/testimage --buildplace $(pwd)/testbuild/ --logfile pbuilder-user-mode-linux-build-dsh-${distribution}.log testbuild/dsh*.dsc
	rm -rf testbuild testimage
    done
fi



