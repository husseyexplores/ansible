#!/usr/bin/env bash
set -euo pipefail

TARGET="file.txt"
WORDLIST="wlist.txt"

while IFS= read -r pw || [[ -n "$pw" ]]; do
  [[ "$pw" == "---" ]] && break

  tmp=$(mktemp)

  # Write password + newline
  printf '%s\n' "$pw" > "$tmp"

  if ansible-vault view --vault-password-file "$tmp" "$TARGET" >/dev/null 2>&1; then
    echo "FOUND: $pw"
    rm -f "$tmp"
    exit 0
  else
    echo "NOT FOUND: $pw"
  fi

  rm -f "$tmp"
done < "$WORDLIST"

echo "No password matched."
exit 1
