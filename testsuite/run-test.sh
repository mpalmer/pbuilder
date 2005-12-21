#!/bin/sh
# This is a testsuite.
# estimated run-time on my PC; 16 minutes.

PBUILDER=/usr/sbin/pbuilder

log_success () {
    CODE=$?
    if [ $CODE = 0 ]; then
	echo "[OK]   $1" >> ${RESULTFILE}
    else
	echo "[FAIL] $1" >> ${RESULTFILE}
    fi
}

[ -x ${PBUILDER} ] || exit 1
[ -x /usr/sbin/debootstrap ] || exit 1
[ -x /usr/bin/cdebootstrap ] || exit 1


#mirror=http://ftp.jp.debian.org/debian
mirror=http://ftp.jp.debian.org/debian-amd64/debian/ 

testdir=$(TMPDIR=$(pwd) mktemp -d)
testimage=$testdir/testimage
testbuild=$testdir/dir1
testbuild2=$testdir/dir2
testbuild3=$testdir/dir3

HOOKOPTION=" --hookdir /usr/share/doc/pbuilder/examples/344089"

for DEBOOTSTRAP in debootstrap cdebootstrap; do
    case $DEBOOTSTRAP in 
	debootstrap)
	    logdir=$(readlink -f normal/)
	    RESULTFILE="run-test.log"
	    unset DEBOOTSTRAPOPTS
	    DEBOOTSTRAPOPTS[0]="--debootstrapopts"
	    DEBOOTSTRAPOPTS[1]="--verbose"
	    ;;
	*)
	    logdir=$(readlink -f $DEBOOTSTRAP)
	    RESULTFILE="run-test-${DEBOOTSTRAP}.log"
	    unset DEBOOTSTRAPOPTS
	    DEBOOTSTRAPOPTS[0]="--debootstrapopts"
	    DEBOOTSTRAPOPTS[1]="--verbose"
	    ;;
    esac
    : > ${RESULTFILE}
    RESULTFILE=$(readlink -f ${RESULTFILE})
    
    for distribution in sid sarge etch; do
	sudo ${PBUILDER} create "${DEBOOTSTRAPOPTS[@]}" --mirror $mirror --debootstrap ${DEBOOTSTRAP} --distribution "${distribution}" --basetgz ${testimage} --logfile ${logdir}/pbuilder-create-${distribution}.log 

	log_success create-${distribution}-${DEBOOTSTRAP}
	
	for PKG in dsh; do 
	    ( 
		mkdir ${testbuild}
		cd ${testbuild}
		apt-get source -d ${PKG}
	    )
	    sudo ${PBUILDER} build --debemail "Junichi Uekawa <dancer@debian.org>" --basetgz ${testimage} --buildplace ${testbuild}/ --logfile ${logdir}/pbuilder-build-${PKG}-${distribution}.log ${testbuild}/${PKG}*.dsc
	    log_success build-${distribution}-${PKG}
	    
	    (
		mkdir ${testbuild2}
		mkdir ${testbuild3}
		cd ${testbuild2}
		apt-get source ${PKG}
		cd ${PKG}-*
		pdebuild --logfile ${logdir}/pdebuild-normal-${distribution}.log -- --basetgz ${testimage} --buildplace ${testbuild3}
		log_success pdebuild-${distribution}-${PKG}
		
		pdebuild --use-pdebuild-internal --logfile ${logdir}/pdebuild-internal-${distribution}.log -- --basetgz ${testimage} --buildplace ${testbuild3}
		log_success pdebuild-internal-${distribution}-${PKG}
	    )
	done
	sudo ${PBUILDER} execute --basetgz ${testimage} --logfile ${logdir}/pbuilder-execute-${distribution}.log ../examples/execute_paramtest.sh test1 test2 test3
	
	# upgrading testing.
	case $distribution in 
	    sarge)
		sudo ${PBUILDER} update $HOOKOPTION --basetgz ${testimage} --distribution etch --mirror $mirror --override-config --logfile ${logdir}/pbuilder-update-${distribution}-etch.log 
		log_success update-${distribution}-etch.log
		sudo ${PBUILDER} update $HOOKOPTION --basetgz ${testimage} --distribution sid --mirror $mirror --override-config --logfile ${logdir}/pbuilder-update-${distribution}-etch-sid.log 
		log_success update-${distribution}-etch-sid.log
		sudo ${PBUILDER} update $HOOKOPTION --basetgz ${testimage} --distribution experimental --mirror $mirror --override-config --logfile ${logdir}/pbuilder-update-${distribution}-etch-sid-experimental.log 
		log_success update-${distribution}-etch-sid-experimental.log
		;;
	    etch)
		sudo ${PBUILDER} update $HOOKOPTION --basetgz ${testimage} --distribution sid --mirror $mirror --override-config --logfile ${logdir}/pbuilder-update-${distribution}-sid.log 
		log_success update-${distribution}-sid.log
		sudo ${PBUILDER} update $HOOKOPTION --basetgz ${testimage} --distribution experimental --mirror $mirror --override-config --logfile ${logdir}/pbuilder-update-${distribution}-sid-experimental.log 
		log_success update-${distribution}-sid-experimental.log
		;;
	esac
	sudo rm -rf ${testbuild} ${testbuild2} ${testimage} ${testbuild3}
    done

    echo '### RESULT: ###'
    cat "${RESULTFILE}"
done

rm -r ${testdir}
