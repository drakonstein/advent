#!/bin/bash

input=2.input
max_dev=3
safe=0
direction=

while read line; do
  fail=false
  read -a report <<< "$line"
  if (( ${report[0]} < ${report[-1]} )); then
    direction=ascending
  else
    direction=descending
  fi
  for (( i=1; i<${#report[@]}; i++ )); do
    num=${report[$i]}
    prev=${report[$((i-1))]}
    if [[ $direction == "ascending" ]]; then
      if (( $num < $prev )); then
        fail=true
        break
      fi
      diff=$(( $num - $prev ))
    elif [[ $direction == "descending" ]]; then
      if (( $num > $prev )); then
        fail=true
        break
      fi
      diff=$(( $prev - $num ))
    fi
    if (( diff > max_dev || diff == 0 )); then
      fail=true
      break
    fi
  done

  if ! $fail; then
    ((safe++))
  fi
done < $input

echo $safe
echo Answer: 332