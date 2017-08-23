#!/bin/sh
# This script prepare the result from bench-lab.sh to be used by ministat and/or gnuplot
# 
set -eu

# An usefull function (from: http://code.google.com/p/sh-die/)
die() { echo -n "EXIT: " >&2; echo "$@" >&2; exit 1; }

## main

[ $# -ne 1 ] && die "usage: $0 benchs-directory"
[ -d $1 ] || die "usage: $0 benchs-directory"

script_dir=`dirname $0`
LAB_RESULTS="$1"

INFO_LIST=$(ls -1 ${LAB_RESULTS}/*.dev-*.start)
[ -z "${INFO_LIST}" ] && die "ERROR: No sysctl files found in ${LAB_RESULTS}"

echo "sdiffing results..."

rm ${LAB_RESULTS}/*.sdiff && echo "Deleting previous .sdiff files"

for INFO in ${INFO_LIST}; do
	base=${INFO%.start}
	if [ ! -f "${base}.end" ]; then
		echo "ERROR: No matching .end file for ${INFO}"
	else
		${script_dir}/sdiff.awk ${INFO} ${base}.end > ${base}.sdiff
	fi
done
