#!/bin/bash
# accept host name as $1
# return unbuilt package, and reserve the package for building.

# exit 1 if no more package is available.
# 2004 1 12, Junichi Uekawa


cd /game/buildd/

#build agent for pbuilder
for A in $( zcat /mirror/debian/dists/sid/main/source/Sources.gz | sed -n 's/^Package: //p' | cut -d\  -f1|sort | uniq | bogosort -n ); do
    #waitingroutine
    if [ $(find -name $A.log | wc -l ) != "0" ]; then
        echo Already build tried for "$A" >&2
    else
        echo $A
        echo "$1 $(date)" > WORKING/$A.log
        exit 0
    fi
done
exit 1

