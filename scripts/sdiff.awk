#!/usr/bin/awk -f

# Split on ':='
BEGIN {
	FS = ": ";
}

# If parsing the first file, save the value and stop
NR==FNR {
	c[$1]=$2;
	next;
}

# Only the second file gets here...

# If the value hasn't changed, stop
c[$1] == $2 {
	next;
}

# If the value is a number, print the diff
$2 + 0 == $2 {
	print $1 ":", c[$1] " -> " $2, "(" $2-c[$1] ")";
	next;
}

# Default to printing old and new
{
	print $1 ":", c[$1] " -> " $2;
}
