#!/bin/bash
# test pbuilder operation with ccache.
set -e 

mkdir work/ccache
chmod 1777 work/ccache
sudo pbuilder build --logfile "$OUTPUT_LOGNAME" --configfile 342665-config work/dsh*.dsc
[ 1 -lt  $(find work/ccache | tee -a "$OUTPUT_LOGNAME" | wc -l ) ];

