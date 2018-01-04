#!/bin/sh

# An usefull function (from: http://code.google.com/p/sh-die/)
die() { echo -n "EXIT: " >&2; echo "$@" >&2; exit 1; }

[ $# -ne 1 ] && die "usage: $0 benchs-directory"
[ -d $1 ] || die "usage: $0 benchs-directory"

script_dir=`dirname $0`
LAB_RESULTS="$1"

echo "Generating FlameGraphs..."
${script_dir}/bench-lab-flamegraph.sh ${LAB_RESULTS}
echo

echo "Generating sdiffs..."
${script_dir}/bench-lab-sdiff.sh ${LAB_RESULTS}
echo

echo -n "Generating ministat..."
${script_dir}/bench-lab-ministat.sh ${LAB_RESULTS}
echo
