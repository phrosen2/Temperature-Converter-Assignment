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

for input_file in inputs:
    num = input_file.replace("input", "").replace(".txt", "")
    output_file = f"{num}expected.txt"

    print(f"""
      - name: test{num} ({POINTS_PER_TEST} pt)
        uses: classroom-resources/autograding-command-grader@v1
        with:
          test-name: test{num}
          command: |
            set -e
            java TempConverter < tests/{input_file} > actual.txt
            if diff --strip-trailing-cr actual.txt tests/{output_file}; then
              echo "PASS"
            else
              exit 1
            fi
          timeout: 2
          max-score: {POINTS_PER_TEST}
""")


#bash -c 'diff <(java TempConverter < tests/{input_file}) tests/{output_file}'
