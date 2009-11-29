#!/bin/bash
# test pbuilder executes the failure script on failure
# run like:
#   rm -r work/; mkdir work/ ; ./526471-pdebuild-fail-scripts.sh

set -e
mkdir work/526471
mkdir work/526471-hook
echo 'echo failpkg-hook-executed' > work/526471-hook/C01_failhook
chmod a+x work/526471-hook/C01_failhook
echo 'echo failpkg-F-hook-executed' > work/526471-hook/F01_hook
chmod a+x work/526471-hook/F01_hook
echo 'echo failpkg-A-hook-executed' > work/526471-hook/A01_hook
chmod a+x work/526471-hook/A01_hook
HOOKDIR=$(readlink -f work/526471-hook)

cd work/526471
dpkg-source -x ../../../random-manual-test-material/failpkg/failpkg_0.1.dsc
cd failpkg-0.1

# the next command fails, but the error code is eaten by pipe; tee succeeds.
pdebuild --use-pdebuild-internal -- --hookdir "${HOOKDIR}" | tee ../526471.log

# I want to check for the output content. C01_failhook should have
# been ran and output there.
grep 'failpkg-hook-executed' 526471.log