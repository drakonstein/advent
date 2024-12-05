#!/bin/bash

input=1.input

left=$(awk '/[0-9]/ {print $1}' $input)
right=$(awk '/[0-9]/ {print $2}' $input)

for l in $left; do
  echo $((l*$(grep -c "^$l$" <<< "$right"))) &
done | awk '{total+=$1}END{print total}'

echo Answer: 21070419