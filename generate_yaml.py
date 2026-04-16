import os

TEST_DIR = "tests"
POINTS_PER_TEST = 1

inputs = sorted([f for f in os.listdir(TEST_DIR) if f.endswith("input.txt")])

print("""name: Autograding

on: [push]

jobs:
  run-autograding-tests:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Compile
        run: javac *.java
""")

tests = []
for input_file in inputs:
    num = input_file.replace("input", "").replace(".txt", "").replace("_","")
    output_file = f"{num}_expected.txt"
    tests.append(f"test{num}")

    print(f"""
      - name: test{num} ({POINTS_PER_TEST} pt)
        id: test{num}
        uses: classroom-resources/autograding-command-grader@v1
        with:
          test-name: test{num}
          command: |
            java TempConverter < tests/{input_file} > actual.txt
            # Extract the expected value from your file
            EXPECTED_VAL=$(cat tests/{output_file})
            # Search for that value inside the student's output
            if grep -q -- "$EXPECTED_VAL" actual.txt; then
              echo "PASS"
            else
              echo "FAIL: Could not find $EXPECTED_VAL in output."
              echo "Student output was:"
              cat actual.txt
              exit 1
            fi
          timeout: 2
          max-score: {POINTS_PER_TEST}
""")

print(f"""
      - name: Autograding Reporter
        uses: classroom-resources/autograding-grading-reporter@v1
        env:""")
x = 1
for test in tests:
    print(f"""          TEST{x}_RESULTS: "${{{{steps.{test}.outputs.result}}}}" """)
    x += 1
print(f"""
        with:
          runners: """, end="")
print(",".join(tests), end="")
