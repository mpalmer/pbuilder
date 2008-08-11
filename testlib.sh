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
    local val
    val="$1"; 
    shift 
    if [ $( "$@" ) = "$1" ]; then
	testlib_echo "OK" "$1"
    else
	testlib_echo "FAIL" "$1"
    fi
}

#   Write your functions test_xxxx and call them at the end with their expected result code:
# . ./testlib.sh
# expect_success test_success
# expect_success test_fail
# expect_success test_options "hello world"
# testlib_summary 

