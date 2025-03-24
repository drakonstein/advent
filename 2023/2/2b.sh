#!/bin/bash

sum=0
colors="red green blue"
while read line; do
  power=1
  declare -A max
  for color in $colors; do
    max[$color]=0
  done
  game=$(echo "$line" | cut -d: -f1 | grep -Eo '[[:digit:]]+')
  while read cubes; do
    while read num color; do
      (( ${max[$color]} < $num )) && max[$color]=$num
    done <<< "$(echo "$cubes" | tr ',' '\n')"
  done <<< "$(echo "$line" | cut -d: -f2 | tr ';' '\n')"
  for color in $colors; do
    ((power*=${max[$color]}))
  done
  echo "$game: $power"
  ((sum+=power))
done < 2.input
echo $sum
