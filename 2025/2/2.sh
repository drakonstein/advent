#!/bin/bash

input=2.input

sum=0

while read first last; do
  (( ${#first} == ${#last} && ${#first} % 2 != 0 )) && continue
  for i in $(seq $first 1 $last); do
    (( ${#i} %2 != 0 )) && continue
    half=$(( ${#i} / 2 ))
    [[ ${i:0:$half} == ${i:$half} ]] && (( sum+=i ))
  done
done <<< $(sed 's/-/ /g; s/,/\n/g' $input)

echo $sum
echo Answer: 8576933996