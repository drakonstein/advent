#!/bin/bash

readarray -t grid < 16.input
declare -A energized
declare -A symbols=( [N,\\]=W [N,/]=E [N,-]="split E W" [N,\|]=N [S,\\]=E [S,/]=W [S,-]="split E W" [S,\|]=S [E,\\]=S [E,/]=N [E,-]=E [E,\|]="split N S" [W,\\]=N [W,/]=S [W,-]=W [W,\|]="split N S" [N,.]=N [S,.]=S [E,.]=E [W,.]=W )
ROWS=${#grid[@]}
COLS=${#grid[0]}

follow() {
  local r=$1
  local c=$2
  local direction=$3
  while true; do
    (( c < 0 )) || (( r < 0 )) || (( c >= COLS )) || (( r >= ROWS )) && return
    [[ ${energized[$r,$c,direction]} =~ $direction ]] && return
    energized[$r,$c]=true
    energized[$r,$c,direction]+=$direction
    local symbol=${grid[$r]:$c:1}
    direction=${symbols[$direction,$symbol]}
    case $direction in
      split\ N\ S)
        follow $((r-1)) $c N
        direction=S
        ((r++))
        ;;
      split\ E\ W)
        follow $r $((c+1)) E
        direction=W
        ((c--))
        ;;
      N)
        ((r--))
        ;;
      S)
        ((r++))
        ;;
      E)
        ((c++))
        ;;
      W)
        ((c--))
        ;;
    esac
  done
}

follow 0 0 E

grep -o true <<< ${energized[@]} | wc -l
echo Answer: 6978