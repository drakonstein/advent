#!/bin/bash

input=2.input
max_dev=3
safe=0
direction=
report=()

report_is_safe() {
  local skip=$1
  start=0
  end=$(( ${#report[@]} - 1 ))
  (( skip == start )) && (( start++ ))
  (( skip == end )) && (( end-- ))
  if (( ${report[$start]} < ${report[$end]} )); then
    direction=ascending
  else
    direction=descending
  fi
  prev=${report[$start]}
  for (( i=$((start+1)); i<=end; i++ )); do
    (( i == skip )) && continue
    num=${report[$i]}
    if [[ $direction == "ascending" ]]; then
      if (( num < prev )); then
        return 1
      fi
      diff=$((num-prev))
    elif [[ $direction == "descending" ]]; then
      if (( num > prev )); then
        return 1
      fi
      diff=$((prev-num))
    fi
    if (( diff > max_dev || diff == 0 )); then
      return 1
    fi
    prev=$num
  done
  echo y
  return 0
}

while read line; do
  read -a report <<< "$line"
  for i in ${!report[@]}; do
    report_is_safe $i && break
  done &
done < $input | grep -o y | grep -c y

echo Answer: 398