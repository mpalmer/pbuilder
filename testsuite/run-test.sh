#!/bin/sh
# This is a testsuite.
PBUILDER_UML=/usr/bin/pbuilder-user-mode-linux

if [ -x "${PBUILDER_UML}" ]; then
    pbuilder-user-mode-linux create --distribution sid --uml-image $(pwd)/testimage --logfile pbuilder-user-mode-linux-create.log
    ( 
	mkdir testbuild
	cd testbuild
	apt-get source -d dsh
    )
    pbuilder-user-mode-linux build --uml-image $(pwd)/testimage --buildplace $(pwd)/testbuild/ --logfile pbuilder-user-mode-linux-build-dsh.log testbuild/dsh*.dsc
    rm -rf testbuild
fi


