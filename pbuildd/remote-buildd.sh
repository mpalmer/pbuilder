#!/bin/bash
# all-rebuilder script.
# remote-agent. runs on remote machine and runs with master node.
# 2004 01 12

set -e

. buildd-config.sh

NOBUILDDEP=${BASEDIRECTORY}/FAILED/NOBUILDDEP
FAILED=${BASEDIRECTORY}/FAILED
DEPWAIT=${BASEDIRECTORY}/DEPWAIT
SUCCESS=${BASEDIRECTORY}/SUCCESS
DEPWAIT=${BASEDIRECTORY}/DEPWAIT
mkdir "$FAILED" || true
mkdir "$DEPWAIT" || true
mkdir "$SUCCESS" || true
mkdir "$DEPWAIT" || true
mkdir ${BASEDIRECTORY}/WORKING || true
mkdir ${BASEDIRECTORY}/STATUS || true
mkdir "$NOBUILDDEP" || true
BUILDRESULTDIR=${PWD}/RESULT-deb
mkdir "$BUILDRESULTDIR" || true

STATUSFILE=${BASEDIRECTORY}/STATUS/$(hostname)-$$
BUILDTMP=${BASEDIRECTORY}/tmp-b-$(hostname)-$$

function status () {
    echo "$@" > $STATUSFILE
    echo "$@"
}

function buildone() {
    local PROGNAME="$1"
    local LOGFILE=${BASEDIRECTORY}/WORKING/"$PROGNAME.log"


    # this part needs to be atomic
    status "considering $PROGNAME"
    if grep "$PROGNAME" avoidlist; then
        echo Skip.
        return
    fi
    if echo "$PROGNAME" | grep "^kernel-image"; then
        echo I hate kernel images.
        return
    fi

    # end of atomic.

    status "building $PROGNAME"
    mkdir $BUILDTMP || true
    (
        cd $BUILDTMP
        apt-get source -d $PROGNAME
        if /usr/sbin/pbuilder build --hookdir "${HOOKDIR}" --buildresult . --logfile "$LOGFILE" *.dsc; then
                scp "$LOGFILE" "$MASTER:$SUCCESS"
            mv "$LOGFILE" "$SUCCESS"
            echo Build successful
        else
            if grep "^E: pbuilder: Could not satisfy build-dependency." $LOGFILE > /dev/null; then
                scp "$LOGFILE" "$MASTER:$DEPWAIT"
                mv "$LOGFILE" "$DEPWAIT"
                echo Dependency cannot be satisfied.
            elif [ $(awk '/ -> Attempting to parse the build-deps/,/^ -> Finished parsing the build-deps/{print $0}' $LOGFILE | wc -l ) = "2" ]; then
                echo "Missing build-deps"
                scp "$LOGFILE" "$MASTER:$NOBUILDDEP"
                mv "$LOGFILE" "$NOBUILDDEP"
            elif grep '^E: Could not satisfy build-dependency' "$LOGFILE" > /dev/null ; then
                echo "Build-dep wait"
                scp "$LOGFILE" "$MASTER:$DEPWAIT"
                mv "$LOGFILE" "$DEPWAIT"
            else
                cat "$LOGFILE" | fsh $MASTER mail -s "\"pbuilder-FTBFS [$(hostname)] $(basename $LOGFILE) \"" dancer-pbuildlog@netfort.gr.jp
                scp "$LOGFILE" "$MASTER:$FAILED"
                mv "$LOGFILE" "$FAILED"
                echo Build failed
            fi
        fi
    )
    status "finished building $PROGNAME"
    rm -rf $BUILDTMP;
}


$ROOTCOMMAND dselect update
$ROOTCOMMAND /usr/sbin/pbuilder update
#pbuilder-user-mode-linux update


while sleep 1s; do
    A=$( ssh $MASTER /game/buildd/build-agent.sh $(hostname ) );
    if [ $? = 1 ]; then
        exit ;
    fi
    buildone $A
done

