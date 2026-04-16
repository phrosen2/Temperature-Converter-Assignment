#!/bin/bash

set -e

javac *.java

pass=true

for i in tests/input*.txt; do
    num=$(basename $i | grep -o '[0-9]*')
    expected="tests/expected_${num}.txt"

    actual=$(java TempConverter < "$i")

    if diff <(echo "$actual") "$expected" > /dev/null; then
        echo "Test $num: PASS"
    else
        echo "Test $num: FAIL"
        pass=false
    fi
done

if [ "$pass" = false ]; then
    exit 1
fi
