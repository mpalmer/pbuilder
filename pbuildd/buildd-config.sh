# this is the configuration for buildd-pbuilder.

BASEDIRECTORY=/mnt/buildd
MIRROR=202.23.147.34
HOOKDIR=/mnt/buildd/pbuilder-buildd/hookdir
ROOTCOMMAND=sudo

# the following is one sample:
function waitingroutine () {
    while sleep 1s; do
    	if ps ax | grep "x[l]ock"; then
		# if xlock does exist, break from loop
		break
	fi
    done
}