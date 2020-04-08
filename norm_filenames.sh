#!/bin/bash

# Usage:

# Dry-run:
# ./norm_filenames.sh <dir> [<dir2>...<dirn>]
#
# Rename files:
# dry=0 ./norm_filenames.sh <dir> [<dir2>...<dirn>]

regex='s,^.\+\(Aula .\+\.mp4\).\+$,\1,g'
dry=${dry:-1}

while IFS= read -r -d $'\0' f; do
  dir="$(dirname "$f")"
  new_name="${dir}/$(echo "$f" | sed "$regex" | tr ' ' '_')"
  cmd="mv $(printf "%q\n" "$f") '${new_name}'"
  echo "-> '$new_name'"
  (( dry )) || eval $cmd
done < <(find "$@" -type f -print0)

# vim: ts=2 sw=4 et filetype=sh

