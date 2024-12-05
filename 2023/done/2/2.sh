#!/bin/bash

declare -A MAX
MAX['red']=12
MAX['green']=13
MAX['blue']=14
sum=0

while read line; do
  BREAK=false
  game=$(echo "$line" | cut -d: -f1 | grep -Eo '[[:digit:]]+')
  while read cubes; do
    while read num color; do
      (( ${MAX[$color]} < $num )) && BREAK=true
    done <<< "$(echo "$cubes" | tr ',' '\n')"
    $BREAK && break
  done <<< "$(echo "$line" | cut -d: -f2 | tr ';' '\n')"
  $BREAK || ((sum+=game))
done < 2.input
echo $sum
unset MAX
