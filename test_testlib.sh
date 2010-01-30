#!/bin/bash
# testsuite for testlib

if [ -n "$PBUILDER_CHECKOUT" ]; then
    . "$PBUILDER_CHECKOUT/testlib.sh"
else
    # these currently don't need to be exported
    PBUILDER_TEST_ROOT="${PBUILDER_ROOT:-}"
    PBUILDER_TEST_PKGLIBDIR="${PBUILDER_PKGLIBDIR:-$PBUILDER_ROOT/usr/lib/pbuilder}"
    . "$PBUILDER_TEST_PKGLIBDIR/testlib.sh"
fi

test_success() {
    exit 0
}

test_fail() {
    exit 1
}

test_options() {
    echo "$@"
    exit 1
}

test_output() {
    echo "$@"
}

expect_success test_success
expect_fail test_fail
expect_fail test_options "hello world"
expect_output "foo bar" test_output "foo" "bar"
testlib_summary
