#!/bin/bash
# test pdebuild --pkgname-logfile
set -e 

exec > "$OUTPUT_LOGNAME" 2>&1 
mkdir work/result
sudo pbuilder build --pkgname-logfile --buildresult work/result/ work/dsh*.dsc
ls -1 work/result
[ -f work/result/dsh*$(dpkg --architecture).build ]
