#!/bin/bash

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

echo "Indexing $SRC_DIR..." >&2
find $SRC_DIR -type f -print0 | xargs -0 md5sum -b | sort > $SRC_HASHES_FILE

echo "Indexing $DST_DIR..." >&2
find $DST_DIR -type f -print0 | xargs -0 md5sum -b | sort > $DST_HASHES_FILE

echo "Finding dups..." >&2
join -j1 $SRC_HASHES_FILE $DST_HASHES_FILE > $DUP_HASHES_FILE

echo -ne "\n### Duplicated files found:\n\n" >&2
cat $DUP_HASHES_FILE
echo >&2

(( DBG )) && print_debug_info >&2

# vim: ts=2 sw=4 et filetype=sh
