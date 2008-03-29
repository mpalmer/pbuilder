#!/bin/bash

# run this script after doing git-dch -R --since debian/0.xxx and
# massaging the changelog a bit.

VERSION=$(dpkg-parsechangelog | sed -n 's/^Version: //p')
git-tag -s -u dancer@debian.org -m "pbuilder release $VERSION" debian/$VERSION

