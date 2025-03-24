#!/bin/bash

sum=0
re_solved='^[0 ]+$'

while read line; do
  declare -A diffs
  i=0
  diffs[$i]=$line
  while ! [[ ${diffs[$i]} =~ $re_solved ]]; do
    nums=( ${diffs[$i]} )
    diff=
    for n in ${!nums[@]}; do
      [[ -z "${nums[$((n+1))]}" ]] && break
      diff+="$(( nums[$((n+1))] - nums[$n] )) "
    done
    ((i++))
    diffs[$i]=$diff
  done

  new=0
  for (( n=${#diffs[@]}-1; n >= 0; n-- )); do
    [[ ${diffs[$n]} =~ ^(-?[[:digit:]]+) ]]
    new=$(( BASH_REMATCH[1] - new ))
  done
  ((sum+=new))
  unset diffs
done < 9.input

echo $sum
echo Answer: 948