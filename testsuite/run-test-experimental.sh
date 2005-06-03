#!/bin/sh
# test for experimental support.

(
    sudo pbuilder create --distribution sid --basetgz /var/tmp/experimental.tgz
    echo this should succeed:
    echo  apt-get -f install lv | sudo pbuilder login --basetgz /var/tmp/experimental.tgz
    echo this should be a success: $?
    sudo pbuilder create --distribution experimental --basetgz /var/tmp/experimental.tgz
    echo this should fail:
    echo  apt-get -f install lv | sudo pbuilder login --basetgz /var/tmp/experimental.tgz
    echo should be a failure: $?
    sudo pbuilder create --distribution unstable --basetgz /var/tmp/experimental.tgz
    sudo pbuilder update --distribution experimental --override-config --basetgz /var/tmp/experimental.tgz
    echo this should fail also:
    echo  apt-get -f install lv | sudo pbuilder login --basetgz /var/tmp/experimental.tgz
    echo should be a failure: $?
) 2>&1 | tee run-test-experimental.log


