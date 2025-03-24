#!/bin/bash

readarray -t grid < 16.input
declare -A symbols=( [N,\\]=W [N,/]=E [N,-]="split E W" [N,\|]=N [S,\\]=E [S,/]=W [S,-]="split E W" [S,\|]=S [E,\\]=S [E,/]=N [E,-]=E [E,\|]="split N S" [W,\\]=N [W,/]=S [W,-]=W [W,\|]="split N S" [N,.]=N [S,.]=S [E,.]=E [W,.]=W )
declare -A energized
declare -A counts
ROWS=${#grid[@]}
COLS=${#grid[0]}
iter=0

follow() {
  local start=$4
  local r=$1
  local c=$2
  local direction=$3
  while true; do
    (( c < 0 )) || (( r < 0 )) || (( c >= COLS )) || (( r >= ROWS )) && return
    [[ ${energized[$start,$r,$c,direction]} =~ $direction ]] && return
    ${energized[$start,$r,$c]:-false} || ((counts[$start]++))
    energized[$start,$r,$c]=true
    energized[$start,$r,$c,direction]+=$direction
    local symbol=${grid[$r]:$c:1}
    direction=${symbols[$direction,$symbol]}
    case $direction in
      split\ N\ S)
        follow $((r-1)) $c N $start
        direction=S
        ((r++))
        ;;
      split\ E\ W)
        follow $r $((c+1)) E $start
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

for (( r=0; r<ROWS; r++ )); do
  follow $r 0 E $r,0,E
  follow $r $((COLS-1)) W $r,$((COLS-1)),W
done

for (( c=0; c<COLS; c++ )); do
  follow 0 $c S 0,$c,S
  follow $((ROWS-1)) $c N $((ROWS-1)),$c,N
done

max=0
for i in ${!counts[@]}; do
  if (( max < counts[$i] )); then
    max=${counts[$i]}
    start=$i
  fi
done

echo $max $start $iter
echo Answer: 7315