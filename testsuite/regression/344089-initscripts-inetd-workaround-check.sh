#!/bin/bash
#make sure that workaround for #344089, and #262627 work.

sudo cp /var/cache/pbuilder/base-sarge.tgz work/base-unstable.tgz
sudo pbuilder update  --logfile "$OUTPUT_LOGNAME" --distribution unstable --basetgz work/base-unstable.tgz --hookdir /usr/share/doc/pbuilder/examples/344089 --override-config

