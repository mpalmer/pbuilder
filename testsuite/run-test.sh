#!/bin/sh
# This is a testsuite.
PBUILDER_UML=/usr/bin/pbuilder-user-mode-linux

if [ -x "${PBUILDER_UML}" ]; then
    pbuilder-user-mode-linux create --distribution sid --uml-image $(pwd)/testimage --logfile pbuilder-user-mode-linux-create.log
fi


