#!/bin/bash
# pbuilder example script.
# Copyright 2003 Junichi Uekawa
#Distributed under GPL version 2 or later

#before running this script, make sure you have an up-to-date system with
# pbuilder update.
# $Id$


# This will install a package using APT and see if that fails.

set -ex

apt-get install -y "$1"


