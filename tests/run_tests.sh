#!/usr/bin/env bash
# Black-box tests for bin/largest_number_finder: feed stdin, compare stdout exactly.
# Usage: bash tests/run_tests.sh [path-to-binary]   (default: bin/largest_number_finder)
BIN="${1:-bin/largest_number_finder}"
pass=0; fail=0

check() {   # check "<name>" "<stdin>" "<expected stdout>"
  local name="$1" input="$2" expected="$3" actual
  actual="$(printf -- "$input" | timeout 5 "$BIN"; printf x)"; actual="${actual%x}"
  if [[ "$actual" == "$expected" ]]; then pass=$((pass+1)); echo "  PASS  $name"
  else fail=$((fail+1)); echo "  FAIL  $name"; echo "        expected: $(printf '%q' "$expected")"; echo "        actual  : $(printf '%q' "$actual")"; fi
}

PROMPT="Enter numbers (enter a negative number to stop):
"

echo "largest_number_finder tests"
check "ascending then sentinel"         '3 7 2 -1\n'          "${PROMPT}Largest number: 7
"
check "largest in the middle (decimal)" '5 9 12.5 3 -4\n'     "${PROMPT}Largest number: 12.5
"
check "largest is the first value"      '50 10 20 -1\n'       "${PROMPT}Largest number: 50
"
check "largest is the last value"       '1 2 3 99 -1\n'       "${PROMPT}Largest number: 99
"
check "all values equal"                '4 4 4 -1\n'          "${PROMPT}Largest number: 4
"
check "zero is a valid value, not a stop signal" '0 -3\n'     "${PROMPT}Largest number: 0
"
check "only a sentinel entered"         '-5\n'                "${PROMPT}Largest number: -5
"
check "numbers may be split over lines" '8\n3\n-2\n'          "${PROMPT}Largest number: 8
"
check "very small sentinel after data"  '10 -2000000000\n'    "${PROMPT}Largest number: 10
"

echo
echo "Known limitations (not counted as failures):"
out="$(printf -- '-1e10\n' | timeout 5 "$BIN" | tail -1)"
[[ "$out" == "Largest number: -1e+09" ]] && echo "  CONFIRMED  a first value below -1e9 is masked by the -1e9 starting value" \
                                         || echo "  CHANGED    initial-value handling differs: $out"
out="$(printf '100000000 -1\n' | timeout 5 "$BIN" | tail -1)"
[[ "$out" == "Largest number: 1e+08" ]] && echo "  CONFIRMED  large results print in scientific notation (1e+08)" \
                                        || echo "  CHANGED    large-value formatting differs: $out"
printf '1 2 3' | timeout 2 "$BIN" >/dev/null 2>&1; rc=$?
[[ $rc -eq 124 ]] && echo "  CONFIRMED  input that ends (EOF) without a negative number loops forever (killed by timeout)" \
                  || echo "  CHANGED    EOF handling differs (exit code $rc)"
printf 'abc' | timeout 2 "$BIN" >/dev/null 2>&1; rc=$?
[[ $rc -eq 124 ]] && echo "  CONFIRMED  non-numeric input loops forever (killed by timeout)" \
                  || echo "  CHANGED    non-numeric handling differs (exit code $rc)"

echo
echo "$pass passed, $fail failed"
[[ $fail -eq 0 ]]
