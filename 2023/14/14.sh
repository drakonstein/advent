#!/bin/bash

declare -A rows
readarray -t grid < 14.input

for (( c=0; c<${#grid[0]}; c++ )); do
  row=0
  for r in ${!grid[@]}; do
    case ${grid[$r]:$c:1} in
      O)
        ((rows[$((row++))]++))
        ;;
      \#)
        row=$(( r + 1 ))
        ;;
    esac
  done
done

mult=${#grid[@]}

sum=0
for row in ${!grid[@]}; do
  ((sum+=mult--*${rows[$row]:-0}))
done

echo $sum
echo Answer: 107951