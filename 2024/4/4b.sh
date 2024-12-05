#!/bin/bash

readarray -t grid < 4.input
ROWS=${#grid[@]}
COLS=${#grid[0]}

for (( r=1; r<ROWS-1; r++ )); do
  for (( c=1; c<COLS-1; c++ )); do
    [[ ${grid[$r]:$c:1} == 'A' ]] &&
     [[ ${grid[$((r-1))]:$((c-1)):1} == 'M' && ${grid[$((r+1))]:$((c+1)):1} == 'S' ||
        ${grid[$((r-1))]:$((c-1)):1} == 'S' && ${grid[$((r+1))]:$((c+1)):1} == 'M' ]] &&
     [[ ${grid[$((r-1))]:$((c+1)):1} == 'M' && ${grid[$((r+1))]:$((c-1)):1} == 'S' ||
        ${grid[$((r-1))]:$((c+1)):1} == 'S' && ${grid[$((r+1))]:$((c-1)):1} == 'M' ]] &&
      echo y
  done &
done | grep -o y | grep -c y

echo Answer: 1972