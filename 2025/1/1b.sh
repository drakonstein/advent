#!/bin/bash

input=1.input
pos=50
count=0

while read line; do
  direction=${line:0:1}
  num=${line:1}
  case $direction in
    R)
      new_pos=$(( pos + num ))
      (( count+=new_pos/100 ))
      pos=$(( new_pos % 100 ))
    ;;
    L)
      (( count+=num/100 ))
      (( num%=100 ))
      (( pos == 0 )) && (( pos+=100 ))
      new_pos=$(( pos - num ))
      if (( new_pos < 0 )); then
        (( count++ ))
        pos=$(( new_pos + 100 ))
      else
        pos=$new_pos
      fi
      [[ $pos == 0 ]] && (( count++ ))
    ;;
  esac
done < $input

echo $count
echo Answer: 5887
