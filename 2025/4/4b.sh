#!/bin/bash

input=4.input
readarray -t grid < $input
cols=${#grid[0]}
rows=${#grid[@]}

check_block() {
  (( $1 < 0 || $1 >= rows || $2 < 0 || $2 >= cols )) && return
  echo "$1 $2 ${grid[$1]:$2:1}"
}

check_blockages() {
  local row=$1
  local col=$2
  check_block $((row-1)) $((col-1))
  check_block $((row-1)) $col
  check_block $((row-1)) $((col+1))
  check_block $row $((col-1))
  check_block $row $((col+1))
  check_block $((row+1)) $((col-1))
  check_block $((row+1)) $col
  check_block $((row+1)) $((col+1))
}

update_grid() {
  while read row col; do
    grid[$row]=${grid[$row]:0:$col}x${grid[$row]:$((col+1))}
  done <<< "$1"
}

updates=$(for row in ${!grid[@]}; do
  grep -q '@' <<< ${grid[$row]} || continue
  for (( col=0; col<cols; col++ )); do
    [[ "${grid[$row]:$col:1}" != "@" ]] && continue
    blockages=$(check_blockages $row $col)
    if (( $(grep -c '@' <<< $blockages) < 4 )); then
      echo "$row $col"
    fi
  done &
done)
update_grid "$updates"

while true; do
  rolls_to_check=$(while read row col; do
    ( check_blockages $row $col | grep '@' ) &
  done <<< "$updates" | sort -u)

  updates=$(while read row col junk; do
    (
      blockages=$(check_blockages $row $col)
      if (( $(grep -c '@' <<< $blockages) < 4 )); then
        echo "$row $col"
      fi
    ) &
  done <<< "$rolls_to_check")
  [[ -z "$updates" ]] && break
  update_grid "$updates"
done

grep -o 'x' <<< ${grid[@]} | wc -l
echo Answer: 8184
