#!/bin/bash

input=3.input

find_max() {
  grep -oP '.' <<< ${1} | sort -n | tail -n1
}

max_nums=$(while read line; do
  (
    num=
    next=
    for (( n=11; n>0; n-- )); do
      next=$(find_max ${line:0:-$n})
      num=$num$next
      line=${line#*$next}
    done
    num=$num$(find_max $line)
    echo $num
  ) &
done < $input)

awk '{sum+=$1} END{print sum}' <<< $max_nums
echo Answer: 172981362045136