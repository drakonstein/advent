#!/bin/bash

input=4.input
readarray -t grid < $input
cols=${#grid[0]}
rows=${#grid[@]}

check_block() {
  (( $1 < 0 || $1 >= rows || $2 < 0 || $2 >= cols )) && return
  echo "$1:$2 = ${grid[$1]:$2:1}"
}

while true; do
  updates=$(for row in ${!grid[@]}; do
    grep -q '@' <<< ${grid[$row]} || continue
    for (( col=0; col<cols; col++ )); do
      [[ "${grid[$row]:$col:1}" != "@" ]] && continue
      blockages=$(
        check_block $((row-1)) $((col-1))
        check_block $((row-1)) $col
        check_block $((row-1)) $((col+1))
        check_block $row $((col-1))
        check_block $row $((col+1))
        check_block $((row+1)) $((col-1))
        check_block $((row+1)) $col
        check_block $((row+1)) $((col+1))
      )
      if (( $(grep -c '@' <<< $blockages) < 4 )); then
        echo "$row $col"
      fi
    done &
  done)
  [[ -z "$updates" ]] && break
  while read r c; do
    grid[$r]=${grid[$r]:0:$c}x${grid[$r]:$((c+1))}
  done <<< "$updates"
done

grep -o 'x' <<< ${grid[@]} | wc -l
echo Answer: 8184
