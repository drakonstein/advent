#!/bin/bash

input=2.input

matches=$(while read first last; do
  for i in $(seq $first 1 $last); do
    grep -E '^([0-9]+)\1+$' <<< $i
  done &
done <<< $(sed 's/-/ /g; s/,/\n/g' $input))

awk '{sum+=$1} END{print sum}' <<< $matches
echo Answer: 25663320831
