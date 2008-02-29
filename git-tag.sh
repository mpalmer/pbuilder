VERSION=$(dpkg-parsechangelog | sed -n 's/^Version: //p')
git-tag -s -u dancer@debian.org -m "pbuilder release $VERSION" debian/$VERSION

