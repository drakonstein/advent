#!/bin/bash

input=3.input

find_max() {
  grep -oP '.' <<< ${1} | sort -n | tail -n1
}

max_nums=$(while read line; do
  (
    first=$(find_max ${line%?})
    num=$first$(find_max ${line#*$first})
    echo $num
  ) &
done < $input)

awk '{sum+=$1} END{print sum}' <<< $max_nums
echo Answer: 17346