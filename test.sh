#!/usr/bin/env bash
set -e -o pipefail

main () {
    source ./conf.sh
    dscripts/build.sh
    dscripts/push.sh
    test_get_metadata
    dscripts/sign.sh
    dscripts/verify.sh
    dscripts/run.sh -ip echo OK
}


test_get_metadata() {
    key='capabilities'
    expected_value='--cap-drop=all'
    value=$(dscripts/get_metadata.py $IMAGENAME $key)
    if [ "$value" == "$expected_value" ]; then
        echo "test passed"
    else
        echo "test failed: expected $expected_value, but found $value."
    fi
}


main