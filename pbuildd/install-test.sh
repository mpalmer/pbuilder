#!/bin/bash
# all-rebuilder script.

set -e

. buildd-config.sh

SUCCESS=install-success
FAIL=install-fail
WORKING=install-work
mkdir $SUCCESS || true
mkdir $FAIL || true
mkdir $WORKING || true

function buildone() {
    local PROGNAME="$1"
    local LOGFILE=${WORKING}/"$PROGNAME.log"

    echo "Trying $1"
    if pbuilder-user-mode-linux execute --logfile "$LOGFILE" /usr/share/doc/pbuilder/examples/execute_installtest.sh "$1"; then
	mv "$LOGFILE" "$SUCCESS"
	echo "  Install successful"
    else
	mv "$LOGFILE" "$FAIL"
	echo "  Install fail"
    fi
}

$ROOTCOMMAND dselect update
#$ROOTCOMMAND pbuilder update 
pbuilder-user-mode-linux update 

tmpfile=$(tempfile)
wget "${MIRROR}"/debian/dists/unstable/main/binary-i386/Packages.gz -O${tmpfile}

for A in $( zcat ${tmpfile} | sed -n 's/^Package: //p' | bogosort -n ); do 
    #waitingroutine
    buildone $A
done

rm -f ${tmpfile}

