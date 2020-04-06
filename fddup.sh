#!/bin/env bash

if [ $# -lt 2 ]; then
  echo "usage: $0 <src_dir> <dest_dir>" >&2
  exit 1
fi

SRC_DIR=$1
DST_DIR=$2
TMP_DIR=$(mktemp -d "dedup.XXXXXXX" -p /tmp)
DBG=${DBG:-0}

print_debug_info() {
  echo "Debug info ====================="
  echo "srcdir: $SRC_DIR"
  echo "dstdir: $DST_DIR"
  echo "tmpdir: $TMP_DIR"
  echo "src hashes: $SRC_HASHES_FILE"
  echo "dest hashes: $DST_HASHES_FILE"
  echo "dup hashes: $DUP_HASHES_FILE"
  echo "==============================="
}

DUP_HASHES_FILE="${TMP_DIR}/dup_hashes.txt"
SRC_HASHES_FILE="${TMP_DIR}/$(sed 's,/,_,g' <<< $SRC_DIR).txt"
DST_HASHES_FILE="${TMP_DIR}/$(sed 's,/,_,g' <<< $DST_DIR).txt"

find $SRC_DIR -type f | xargs md5sum | sort > $SRC_HASHES_FILE
find $DST_DIR -type f | xargs md5sum | sort > $DST_HASHES_FILE

comm -12 \
  <(cut -f1 -d ' ' < ${SRC_HASHES_FILE}) \
  <(cut -f1 -d ' ' < ${DST_HASHES_FILE}) > $DUP_HASHES_FILE

REGEX=$(tr '\n' '|' < $DUP_HASHES_FILE | head -c -1)


echo -ne "############# Duplicated files found:\n\n" >&2
egrep --color=never "$REGEX" $DST_HASHES_FILE | awk '{print $2}'
echo >&2

(( DBG )) && print_debug_info >&2

# vim: ts=2 sw=4 et filetype=sh
