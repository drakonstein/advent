#!/bin/bash

input=5.input
count=0

readarray -t ranges <<< $(grep '\-' $input | sort -V)
ingredients=$(grep -E '^[0-9]+$' $input | sort -n)

rangeid=0
rangemax=${#ranges[@]}
start=${ranges[$rangeid]%-*}
end=${ranges[$rangeid]#*-}

for ingredient in $ingredients; do
  while (( ingredient > end )); do
    (( rangeid > rangemax)) && break
    (( rangeid++ ))
    start=${ranges[$rangeid]%-*}
    end=${ranges[$rangeid]#*-}
  done
  (( rangeid > rangemax)) && break

  (( ingredient >= start && ingredient <= end )) && ((count++))
done


echo $count
echo Answer: 517
