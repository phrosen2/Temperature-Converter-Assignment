#!/bin/bash

set -e

javac *.java

score=0
total=0

for i in tests/*input.txt; do
    num=$(basename $i | grep -o '[0-9]*')
    expected="tests/${num}_expected.txt"
    total=$((total + 1))

    actual=$(java TempConverter < "$i")

    # check for contains instead of exact match (careful with newlines)
    if grep -q -f $expected <(echo "$actual"); then
        echo "Test $num: PASS"
        score=$((score + 1))
    else
        cat $expected
        echo ""
        echo "Test $num: FAIL"
        echo "Could not find $expected in output."
        echo "Student output was:"
        echo "$actual"
    fi


    # diff needs the --strip-trailing-cr to deal with Unix/Windows confusion in output
   # if diff --strip-trailing-cr <(echo "$actual") "$expected" > /dev/null; then
    #    echo "Test $num: PASS"
     #   score=$((score + 1))
 #   else
  #      echo "Test $num: FAIL"
   #     echo "Expected: "
    #    cat $expected
     #   echo "Actually got:"
      #  echo $actual
   # fi
done

#Code Checks
echo "Checking Scanner..."
total=$((total + 1))
if grep -q "Scanner" TempConverter.java; then
    echo "Scanner: PASS (+1)"
    score=$((score + 1))
else
    echo "Scanner: FAIL"
fi


# Final score
echo "----------------------"
echo "SCORE: $score / $total"
echo "----------------------"

