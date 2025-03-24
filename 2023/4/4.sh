#!/bin/bash

sum=0

while read line; do
  mult=0
  winnings=$(echo $line | cut -d: -f2 | cut -d\| -f1)
  numbers=$(echo $line | cut -d\| -f2)
  for winning in $winnings; do
    echo "$numbers " | grep -qEo " $winning " || continue
    if (( mult == 0 )); then
      mult=1
    else
      ((mult*=2))
    fi
  done
  ((sum+=mult))
done < 4.input
echo $sum
