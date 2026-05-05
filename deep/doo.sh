#!/usr/bin/sh

awk -f deep.awk $1  > $1.lst

grep '^~ ' $1.lst > $1.cnt

sort -n -k 4 < $1.cnt > $1.cnts

grep '^= ' $1.lst > $1.cpr

sort -n -k 2 < $1.cpr > $1.cprs

awk -f sums.awk $1.cnt > $1.smt

