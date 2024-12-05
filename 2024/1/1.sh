#!/bin/bash

input=1.input

readarray -t left <<< $(sort -nk1 $input | awk '/[0-9]/ {print $1}')
readarray -t right <<< $(sort -nk2 $input | awk '/[0-9]/ {print $2}')
sum=0
ROWS=${#left[@]}

for (( i=0; i<ROWS; i++ )); do
  diff=$(( ${right[$i]} - ${left[$i]} ))
  ((sum+=${diff#-}))
done

echo $sum
echo Answer: 1223326