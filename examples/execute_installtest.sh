#!/bin/bash
# pbuilder example script.
# Copyright 2003 Junichi Uekawa
#Distributed under GPL version 2 or later

#before running this script, make sure you have an up-to-date system with
# pbuilder update.
# $Id$


# This will install a package using APT and see if that fails.

set -ex

# practically, killing is not enough, do a reboot here instead.
echo 'nobody@nowhere' > /etc/mailname
echo '$Id'
INSTALLTESTPID=$$
( sleep 1h ; kill $INSTALLTESTPID ) &
KILLPID=$!

apt-get install -y "$1" < /dev/null

kill $KILLPID

# known bugs according to Christian Perrier.

# anacron 	MQ	134017
# Base-passwd	CP	184979
		
# exim		86210
# Kernel-package		115884
# Sendmail	CP	?
# wvdial	CP	219151
		
# Nessusd	CP	191925
# Libssl0.9.7		?
		
# php4		122353
# seyon		147269



