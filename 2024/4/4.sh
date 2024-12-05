#!/bin/bash

readarray -t grid < 4.input
ROWS=${#grid[@]}
COLS=${#grid[0]}
XMAS=(X M A S)

is_letter() {
  local r=$1
  local c=$2
  local letter=$3

  (( r < 0 || c < 0 || r >= $ROWS || c >= $COLS )) && return 1
  [[ ${grid[$r]:$c:1} == ${XMAS[$letter]} ]] && return 0 || return 1
}

XMAS_up_left() {
  local r=$1
  local c=$2
  for (( letter=1; letter < 4; letter++ )); do
    ((r--))
    ((c--))
    is_letter $r $c $letter || return 1
  done
  echo y
}

XMAS_up() {
  local r=$1
  local c=$2
  for (( letter=1; letter < 4; letter++ )); do
    ((r--))
    is_letter $r $c $letter || return 1
  done
  echo y
}

XMAS_up_right() {
  local r=$1
  local c=$2
  for (( letter=1; letter < 4; letter++ )); do
    ((r--))
    ((c++))
    is_letter $r $c $letter || return 1
  done
  echo y  
}

XMAS_left() {
  local r=$1
  local c=$2
  for (( letter=1; letter < 4; letter++ )); do
    ((c--))
    is_letter $r $c $letter || return 1
  done
  echo y
}

XMAS_right() {
  local r=$1
  local c=$2
  for (( letter=1; letter < 4; letter++ )); do
    ((c++))
    is_letter $r $c $letter || return 1
  done
  echo y
}

XMAS_down_left() {
  local r=$1
  local c=$2
  for (( letter=1; letter < 4; letter++ )); do
    ((r++))
    ((c--))
    is_letter $r $c $letter || return 1
  done
  echo y
}

XMAS_down() {
  local r=$1
  local c=$2
  for (( letter=1; letter < 4; letter++ )); do
    ((r++))
    is_letter $r $c $letter || return 1
  done
  echo y
}

XMAS_down_right() {
  local r=$1
  local c=$2
  for (( letter=1; letter < 4; letter++ )); do
    ((r++))
    ((c++))
    is_letter $r $c $letter || return 1
  done
  echo y
}

for (( r=0; r<ROWS; r++ )); do
  for (( c=0; c<COLS; c++ )); do
    if is_letter $r $c 0; then
      XMAS_up_left $r $c 
      XMAS_up $r $c
      XMAS_up_right $r $c
      XMAS_left $r $c
      XMAS_right $r $c
      XMAS_down_left $r $c
      XMAS_down $r $c
      XMAS_down_right $r $c
    fi
  done &
done | grep -o y | grep -c y

echo Answer: 2578