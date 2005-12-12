#!/bin/bash
# test pbuilder operation with ccache.

mkdir /tmp/ccache
chmod 1777 /tmp/ccache
sudo pbuilder build --logfile "$OUTPUT_LOGNAME" --configfile 342665-config work/dsh*.dsc
