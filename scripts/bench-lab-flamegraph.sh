#!/bin/sh
# Convert a bunch of *.pmc into *.svg using FlameGraph perl scripts
# https://github.com/brendangregg/FlameGraph
# Need perl and flamegraph installed
set -eu
flamepath="/usr/local/bin"
dir=""
filter=""

usage () {
	echo "$0 result-directory filter"
	echo "example:"
	echo "$0 results/fbsd12-head.r318516.pmc/ sched_idletd"
	exit 0
}

flamegraph_pmc () {
found=false
for i in stackcollapse-pmc.pl flamegraph.pl; do
	[ -f $i ] && die "Didn't found $i into ${flamepath}"
done
for i in ${dir}/*.1.pmc.graph; do
	if [ $i = "${dir}/*.1.pmc.graph" ]; then
		echo "No .graph files found"
		return
	fi
	found=true
	prefix=${i%.1.pmc.graph}
	read graph_title < $i
	title=`basename ${prefix}`
	title="${title#bench.} ${graph_title% \[*\]}"
	if [ -z "${filter}" ]; then
		cat ${prefix}.*.pmc.graph | ${flamepath}/stackcollapse-pmc.pl > ${prefix}.stack
	else
		cat ${prefix}.*.pmc.graph | ${flamepath}/stackcollapse-pmc.pl | grep -v ${filter} > ${prefix}.stack
	fi
	${flamepath}/flamegraph.pl --title="${title}" ${prefix}.stack > ${prefix}.pmc.svg
done
($found) && echo "Done" || echo "No .graph files found"
}

flamegraph_dtrace () {
found=false
for i in stackcollapse.pl flamegraph.pl; do
	[ -f $i ] && die "Didn't found $i into ${flamepath}"
done
for i in ${dir}/*.1.out.stacks; do
	if [ $i = "${dir}/*.1.out.stacks" ]; then
		echo "No .stacks files found"
		return
	fi
	found=true
	prefix=${i%.1.out.stacks}
	title=`basename ${prefix}`
	title="${title#bench.} DTrace output"
	cat ${prefix}.*.out.stacks | ${flamepath}/stackcollapse.pl | ${flamepath}/flamegraph.pl --title="${title}" > ${prefix}.dtrace.svg
done
($found) && echo "Done" || echo "No .stacks files found"
}

### main function ###

if [ $# -lt 1 ] ; then
    echo "$0: Missing argument(s)"
    usage
fi

dir=$1
[ $# -eq 2 ] && filter=$2

flamegraph_pmc
flamegraph_dtrace
