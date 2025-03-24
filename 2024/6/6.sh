#!/bin/bash

input=6.input
start_re='[\^><v]'
block='#'

readarray -t grid < $input
ROWS=${#grid[@]}
COLS=${#grid[0]}

r=$(grep -n $start_re $input)
r=$(( ${r%:*} - 1 ))
c=${grid[$r]%$start_re*}
c=${#c}

case ${grid[$r]:$c:1} in
  '^')
    direction=up
    ;;
  '>')
    direction=right
    ;;
  'v')
    direction=down
    ;;
  '<')
    direction=left
    ;;
esac

while (( r >= 0 && r < ROWS && c >= 0 && c < COLS )); do
  grid[$r]=${grid[$r]:0:$c}X${grid[$r]:$((c+1))}
  case $direction in
    up)
      if [[ ${grid[$((r-1))]:$c:1} == $block ]]; then
        direction=right
      else
        ((r--))
      fi
      ;;
    right)
      if [[ ${grid[$r]:$((c+1)):1} == $block ]]; then
        direction=down
      else
        ((c++))
      fi
      ;;
    down)
      if [[ ${grid[$((r+1))]:$c:1} == $block ]]; then
        direction=left
      else
        ((r++))
      fi
      ;;
    left)
      if [[ ${grid[$r]:$((c-1)):1} == $block ]]; then
        direction=up
      else
        ((c--))
      fi
      ;;
  esac
done

echo ${grid[@]} | grep -o X | grep -c X
echo Answer: 5531