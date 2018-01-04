#!/bin/sh

# An usefull function (from: http://code.google.com/p/sh-die/)
die() { echo -n "EXIT: " >&2; echo "$@" >&2; exit 1; }

usage () { die "usage: $0 benchs-directory destination-directory"; }

[ $# -ne 2 ] && usage
[ -d $1 ] || usage
if [ ! -d $2 -a -e $2 ]; then
	usage
fi

if [ ! -e $2 ]; then
	mkdir -p $2
fi

script_dir=`dirname $0`
LAB_RESULTS="$1"
DEST_DIR="$2"

echo "Generating FlameGraphs..."
${script_dir}/bench-lab-flamegraph.sh ${LAB_RESULTS}
echo

echo "Generating sdiffs..."
${script_dir}/bench-lab-sdiff.sh ${LAB_RESULTS}
echo

echo -n "Generating ministat..."
${script_dir}/bench-lab-ministat.sh ${LAB_RESULTS}
echo

cp ${LAB_RESULTS}/*.svg ${DEST_DIR}/
cp ${LAB_RESULTS}/*.annotate ${DEST_DIR}/
cp ${LAB_RESULTS}/*.sdiff ${DEST_DIR}/
cp ${LAB_RESULTS}/*.pps ${DEST_DIR}/
cp ${LAB_RESULTS}/*.data ${DEST_DIR}/
