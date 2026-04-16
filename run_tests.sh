#!/bin/bash

set -e

javac *.java

score=0
total=0

for i in tests/input*.txt; do
    num=$(basename $i | grep -o '[0-9]*')
    expected="tests/expected_${num}.txt"
    total=$((total + 1))

    actual=$(java TempConverter < "$i")

    if diff <(echo "$actual") "$expected" > /dev/null; then
        echo "Test $num: PASS"
        score=$((score + 1))
    else
        echo "Test $num: FAIL"
    fi
done

#Code Checks
echo "Checking Scanner..."
total=$((total + 1))
if grep -q "Scanner" PA03.java; then
    echo "Scanner: PASS (+1)"
    score=$((score + 1))
else
    echo "Scanner: FAIL"
fi


# Final score
echo "----------------------"
echo "SCORE: $score / $total"
echo "----------------------"

# Fail CI if not perfect (optional)
if [ "$score" -lt "$total" ]; then
    exit 1
fi
