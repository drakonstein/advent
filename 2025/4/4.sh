#!/bin/bash

input=4.input
readarray -t grid < $input
cols=${#grid[0]}
rows=${#grid[@]}

check_block() {
  (( $1 < 0 || $1 >= rows || $2 < 0 || $2 >= cols )) && return
  echo "$1:$2 = ${grid[$1]:$2:1}"
}

total=$(for row in ${!grid[@]}; do
  for (( col=0; col<cols; col++ )); do
    if [[ "${grid[$row]:$col:1}" == "@" ]]; then
      count=$(
        check_block $((row-1)) $((col-1))
        check_block $((row-1)) $col
        check_block $((row-1)) $((col+1))
        check_block $row $((col-1))
        check_block $row $((col+1))
        check_block $((row+1)) $((col-1))
        check_block $((row+1)) $col
        check_block $((row+1)) $((col+1))
      )
      (( $(grep -c '@' <<< $count) < 4 )) && echo "$row:$col = ${grid[$row]:$col:1}"
    fi
  done &
done)

grep -c '@' <<< $total
echo Answer: 1363
