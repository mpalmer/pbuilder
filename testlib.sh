#!/bin/bash
# 2008 Junichi Uekawa <dancer@debian.org>

set -e

# library for functional unit-testing in bash.

# WARNING: this file locates files differently from the other pbuilder
# functions:
# - if PBUILDER_CHECKOUT is set, it is assumed that testlib.sh is sourced from
#   a pbuilder checkout (e.g. from the upstream Makefile or Debian build)
# - otherwise, PBUILDER_TEST_ROOT or PBUILDER_TEST_*DIR should be used to
#   locate files instead of PBUILDER_ROOT and PBUILDER_*DIR since
#   testlib_setup_env() overrides these vars to run the other pbuilder modules
#   with a fake environment

# if this is set, use pbuilder files from this location; otherwise, use
# installed files (from PBUILDER_TEST_ROOT, which is a copy of PBUILDER_ROOT)
PBUILDER_CHECKOUT="${PBUILDER_CHECKOUT:-}"

if [ -z "$PBUILDER_CHECKOUT" ]; then
    # these currently don't need to be exported
    PBUILDER_TEST_ROOT="${PBUILDER_ROOT:-}"
    PBUILDER_TEST_PKGLIBDIR="${PBUILDER_PKGLIBDIR:-$PBUILDER_ROOT/usr/lib/pbuilder}"
    PBUILDER_TEST_PKGDATADIR="${PBUILDER_PKGDATADIR:-$PBUILDER_ROOT/usr/share/pbuilder}"
fi

# set PBUILDER_TEST_VERBOSE to get the full output of tests

TESTLIB_FAILS=0
TESTLIB_TESTS=0

testlib_echo() {
    case "$1" in
      OK)
        shift
        if [ -n "$PBUILDER_TEST_VERBOSE" ]; then
            echo "[OK]" "$@" >&2
        fi
      ;;
      FAIL)
        shift
        echo "[FAIL]" "$@" >&2
        TESTLIB_FAILS=$(($TESTLIB_FAILS + 1))
      ;;
    esac
    TESTLIB_TESTS=$(($TESTLIB_TESTS + 1))
}

testlib_summary() {
    echo "$0: Ran $TESTLIB_TESTS tests and $(($TESTLIB_TESTS - $TESTLIB_FAILS)) succeeded, $TESTLIB_FAILS failed"
    if [ $TESTLIB_FAILS != 0 ]; then
        echo '================='
        echo 'Testsuite FAILED!'
        echo "  $0"
        echo '================='
        return 1
    fi
    return 0
}

# Create fake installed tree with basic config files.  Make sure you trap test
# script exit to call testlib_cleanup_env.  Optional arg is location of the
# pbuilder checkout to copy files from.
# this is where the env actually lives
testlib_env_root=""
testlib_setup_env() {
    local abs_pbuilder_checkout r

    if [ -n "$testlib_env_root" ]; then
        echo "testlib_setup_env called twice without testlib_cleanup_env" >&2
        testlib_cleanup_env
        exit 1
    fi

    if [ -n "$PBUILDER_CHECKOUT" ]; then
        abs_pbuilder_checkout="`cd $PBUILDER_CHECKOUT; pwd`"
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
    if [ -n "$PBUILDER_CHECKOUT" ]; then
        cp "$PBUILDER_CHECKOUT"/pbuilderrc "$r"/usr/share/pbuilder
    else
        cp "$PBUILDER_TEST_PKGDATADIR"/pbuilderrc "$r"/usr/share/pbuilder
    fi
    mkdir -p "$r"/usr/lib
    if [ -n "$PBUILDER_CHECKOUT" ]; then
        ln -s "$abs_pbuilder_checkout" "$r"/usr/lib/pbuilder
    else
        ln -s "$PBUILDER_TEST_PKGLIBDIR" "$r"/usr/lib/pbuilder
    fi
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
    # run the test in subshell; successful commands should not output anything
    # to stderr but may send output to stdout
    if (if [ -z "$PBUILDER_TEST_VERBOSE" ]; then exec >/dev/null; fi; "$@"); then
        testlib_echo "OK" "$1"
    else
        testlib_echo "FAIL" "$1" 
    fi
}

expect_fail() {
    # run the test in subshell; failed commands may output anything to stdout
    # and stderr
    if (if [ -z "$PBUILDER_TEST_VERBOSE" ]; then exec >/dev/null 2>&1; fi; "$@"); then
        testlib_echo "FAIL" "$1"
    else
        testlib_echo "OK" "$1"
    fi
}

expect_output() {
    # run the test in subshell
    local val result
    val="$1"
    shift
    result="`"$@" 2>&1`" || true
    if [ "$result" = "$val" ]; then
        testlib_echo "OK" "$1"
    else
        testlib_echo "FAIL" "$1" "expected [$val] but got [$result]"
    fi
}

