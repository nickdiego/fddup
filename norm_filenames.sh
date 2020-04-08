#!/bin/bash

DIR=$1

regex='s,^.\+\(Aula .\+\.mp4\).\+$,\1,g'
dry=${dry:-1}

for f in ${DIR}/*; do
  if (( dry )); then
    echo "mv -v '$f' '$(echo "$f" | sed "$regex" | tr ' '  '_')'"
  else
    eval "mv -v '$f' '$(echo "$f" | sed "$regex" | tr ' '  '_')'"
  fi
done

# vim: ts=2 sw=4 et filetype=sh

