#!/bin/bash
# 2008 Junichi Uekawa <dancer@debian.org>

set -e 

# library for functional unit-testing in bash.

TESTLIB_FAILS=0
TESTLIB_TESTS=0

testlib_echo() {
    case "$1" in
	OK)
	    # no output is probably good.
    	    ;;
	FAIL)
	    shift
	    echo "[FAIL]" "$@" >&2 
	    TESTLIB_FAILS=$((TESTLIB_FAILS+1))
	    ;;
    esac
    TESTLIB_TESTS=$((TESTLIB_TESTS+1))
}

testlib_summary() {
    echo "$0: Ran ${TESTLIB_TESTS} tests and $((TESTLIB_TESTS - TESTLIB_FAILS)) succeeded, ${TESTLIB_FAILS} failed"
    if [ $TESTLIB_FAILS != 0 ]; then
	echo '================='
	echo 'Testsuite FAILED!'
	echo "  $0"
	echo '================='
	exit 1
    fi
    exit 0
}

# Create fake installed tree with basic config files.  Make sure you trap test
# script exit to call testlib_cleanup_env.  Optional arg is location of the
# pbuilder checkout to copy files from.
# this is where the env actually lives
testlib_env_root=""
testlib_setup_env() {
    local pbuilder_checkout abs_pbuilder_checkout r
    pbuilder_checkout="${1:-.}"
    abs_pbuilder_checkout="`cd $pbuilder_checkout; pwd`"

    if [ -n "$testlib_env_root" ]; then
        echo "testlib_setup_env called twice without testlib_cleanup_env" >&2
        testlib_cleanup_env
        exit 1
    fi

    # backup env vars
    testlib_env_oldhome="$HOME"
    testlib_env_oldroot="$PBUILDER_ROOT"

    testlib_env_root="`mktemp -dt`"
    # brevity
    r="$testlib_env_root"

    mkdir "$r"/etc
    touch "$r"/etc/pbuilderrc
    mkdir -p "$r"/usr/share/pbuilder
    cp "$pbuilder_checkout"/pbuilderrc "$r"/usr/share/pbuilder
    mkdir -p "$r"/usr/lib
    ln -s "$abs_pbuilder_checkout" "$r"/usr/lib/pbuilder
    export PBUILDER_ROOT="$r"
    # when running the testsuite within pbuilder, these env vars will have been
    # set by regular pbuilder commands, so we need to unset them as to allow
    # their default values to be recomputed relative to PBUILDER_ROOT
    unset PBUILDER_PKGLIBDIR PBUILDER_PKGDATADIR PBUILDER_SYSCONFDIR

    mkdir "$r"/home
    touch "$r"/home/.pbuilderrc
    export HOME="$r"/home
}

# Reverse the effect of testlib_setup_env.  Setup a trap handler in your tests
# on this function if you call testlib_setup_env.
testlib_cleanup_env() {
    if [ -z "$testlib_env_root" ]; then
        # nothing to do
        return
    fi
    rm -rf "$testlib_env_root"
    export PBUILDER_ROOT="$testlib_env_oldroot"
    export HOME="$testlib_env_oldhome"
    testlib_env_root=""
}

expect_success() {
    # run the test in subshell
    if (
	"$@"
	); then
	testlib_echo "OK" "$1" 
    else
	testlib_echo "FAIL" "$1" 
    fi
}

expect_fail() {
    # run the test in subshell
    if (
	"$@"
	); then
	testlib_echo "FAIL" "$1"
    else
	testlib_echo "OK" "$1"
    fi
}

expect_output() {
    # run the test in subshell
    local val result
    val="$1"; shift 
    result="$( ( "$@" 2>&1 ) )"|| true
    if [ "${result}" = "${val}" ]; then
	testlib_echo "OK" "$1"
    else
	testlib_echo "FAIL" "$1 reason: [${result}] != [${val}]" 
    fi
}

#   Write your functions test_xxxx and call them at the end with their expected result code:
# . ./testlib.sh
# expect_success test_success
# expect_success test_fail
# expect_success test_options "hello world"
# testlib_summary 

