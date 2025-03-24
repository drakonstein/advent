#!/bin/bash

sum=0
declare -A cards

while read line; do
  card=$(echo $line | cut -d: -f1 | grep -Eo '[[:digit:]]+')
  n=$card
  ((cards[$card]++))
  count=${cards[$card]}
  winnings=$(echo $line | cut -d: -f2 | cut -d\| -f1)
  numbers=$(echo $line | cut -d\| -f2)
  for winning in $winnings; do
    echo "$numbers " | grep -qEo " $winning " || continue
    ((n++))
    ((cards[$n]+=count))
  done
  ((sum+=${cards[$card]}))
done < 4.input
echo $sum
unset cards
