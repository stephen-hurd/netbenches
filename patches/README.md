# Patches required for proper operation #

## freebsd.pkt-gen.ae-ipv6.patch ##

Adds -N, -U, -4, and -6 options.
-U is needed for correct checksums on Intel hardware
-N avoids issues with units
