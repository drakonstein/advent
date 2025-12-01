#!/bin/bash

input=1.input
pos=50
count=0

while read line; do
  case ${line:0:1} in
    R)
      pos=$(( (pos + ${line:1}) % 100 ))
    ;;
    L)
      pos=$(( (pos - ${line:1} + 10000) % 100 ))
    ;;
  esac
  [[ $pos == 0 ]] && (( count++ ))
done < $input

echo $count
echo Answer: 969
