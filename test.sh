#!/bin/bash

# Compile everything
javac *.java 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Your program did not compile. Fix errors before submitting."
  exit 1
fi

# Header checks (same as always)
grep -qE "\*\s*Name:\s*\S+" PA05.java \
  && echo "PASS: Header: Name is filled in" \
  || echo "FAIL: Header: Name is filled in — add your name to the header"

grep -qE "\*\s*Block:\s*\S+" PA05.java \
  && echo "PASS: Header: Block is filled in" \
  || echo "FAIL: Header: Block is filled in — add your block to the header"

grep -qE "\*\s*Date:\s*\S+" PA05.java \
  && echo "PASS: Header: Date is filled in" \
  || echo "FAIL: Header: Date is filled in — add the date to the header"

# Run the Java test runner
java TestRunner
