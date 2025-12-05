#!/bin/bash

input=5.input
count=0
min_start=0

while read start end; do
  (( start < min_start )) && start=$min_start
  (( $end >= $start )) || continue
  (( count += end - start + 1 ))
  min_start=$((end+1))
done <<< $(grep '\-' $input | tr '-' ' ' | sort -nk1)

echo $count
echo Answer: 336173027056994
