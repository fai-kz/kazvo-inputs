#!/bin/bash

set -uo pipefail

cd "$(dirname "$0")"

server_url="${DACHS_TEST_URL:-http://127.0.0.1}"
failed=0
tested=0

mapfile -t test_rds < <(git grep -l '<regSuite' -- '*.rd' | sort)

for rd in "${test_rds[@]}"; do
	tested=$((tested+1))
	printf '\n==> %s\n' "$rd"
	if ! dachs test -n 1 -u "$server_url" "$rd"; then
		failed=$((failed+1))
	fi
done

printf '\nTested %d resource descriptors; %d failed.\n' "$tested" "$failed"
test "$failed" -eq 0
