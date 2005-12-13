#!/bin/bash

log_success () {
    CODE=$?
    if [ $CODE = 0 ]; then
	echo "[OK]   $1" >> ${RESULTFILE}
    else
	echo "[FAIL] $1" >> ${RESULTFILE}
    fi
}

RESULTFILE="run-regression.log"
: > ${RESULTFILE}
RESULTFILE=$(readlink -f ${RESULTFILE})

# prepare files.
(
    mkdir regression/work && \
    cd regression/work && \
    apt-get source dsh
)

(
    cd regression && \
	for A in *.sh; do 
	    OUTPUT_LOGNAME=log/$A.log bash $A 
	    log_success $A
    done
)

sudo rm -rf regression/work/
