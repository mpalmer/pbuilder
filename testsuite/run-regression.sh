#!/bin/bash
# requires /var/cache/pbuilder/base-sarge.tgz


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
	for A in $(ls -1 *.sh | sort -n); do 
	    OUTPUT_LOGNAME=log/$A.log bash $A 
	    log_success $A
    done
)

sudo rm -rf regression/work/
echo '### RESULT: ###'
cat "${RESULTFILE}"
