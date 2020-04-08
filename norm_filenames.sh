#!/bin/bash

# Usage sample:
#
# find test/odd-filenames -type f | ./norm_filenames.sh

regex='s,^.\+\(Aula .\+\.mp4\).\+$,\1,g'
dry=${dry:-1}

while IFS= read -r f; do
  dir="$(dirname "$f")"
  new_name="$(echo "$f" | sed "$regex")"
  cmd="mv '$f' '${dir}/${new_name}'"

  (( dry )) && echo $cmd || eval $cmd
done

# vim: ts=2 sw=4 et filetype=sh

