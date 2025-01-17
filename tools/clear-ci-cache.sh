#!/bin/bash

source "$(dirname "$0")/global.sh"

call_dir=$(pwd)
root=""

cd "$root" || exit

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --root) root="$2"; shift ;;
    *) echo "Unknown parameter passed: $1" ;;
  esac
  shift
done

response=$(gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/Angoliuk/raylib-starter/actions/caches)

if [ $? -eq 0 ]; then
  cache_ids=$(echo "$response" | jq -r '.actions_caches[].id')

  for cache_id in $cache_ids; do
    echo "Deleting cache with id: $cache_id"

    delete_result=$(gh api \
      --method DELETE \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      /repos/Angoliuk/raylib-starter/actions/caches/"$cache_id")

    echo "$delete_result"
  done

else
  echo "Error executing gh api command"
fi

cd "$call_dir" || exit
