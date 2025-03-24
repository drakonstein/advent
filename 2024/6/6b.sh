#!/bin/bash

input=6.input
start_re='[\^><v]'
block='#'
path='X'

readarray -t grid < $input
#up=( ${grid[@]})
#right=( ${grid[@]})
#down=( ${grid[@]})
#left=( ${grid[@]})
ROWS=${#grid[@]}
COLS=${#grid[0]}

start_r=$(grep -n $start_re $input)
start_r=$(( ${start_r%:*} - 1 ))
start_c=${grid[$start_r]%$start_re*}
start_c=${#start_c}
r=$start_r
c=$start_c

case ${grid[$start_r]:$start_c:1} in
  '^')
    DIRECTION=up
    ;;
  '>')
    DIRECTION=right
    ;;
  'v')
    DIRECTION=down
    ;;
  '<')
    DIRECTION=left
    ;;
esac
direction=$DIRECTION

is_loop() {
  local r=$1
  local c=$2
  local direction=$3

  (( r==start_r && c==start_c )) && [[ $direction == $DIRECTION ]] && return 1

  local grid=( ${grid[@]} )

  case $direction in
    up)
      add_block_r=$((r-1))
      add_block_c=$c
      ;;
    right)
      add_block_r=$r
      add_block_c=$((c+1))
      ;;
    down)
      add_block_r=$((r+1))
      add_block_c=$c
      ;;
    left)
      add_block_r=$r
      add_block_c=$((c-1))
      ;;
  esac
  
  [[ ${grid[$add_block_r]:$add_block_c:1} == $block ]] && return 1
  grid[$add_block_r]=${grid[$add_block_r]:0:$add_block_c}${block}${grid[$add_block_r]:$((add_block_c+1))}

  local up=( ${grid[@]} )
  local right=( ${grid[@]} )
  local down=( ${grid[@]} )
  local left=( ${grid[@]} )


  while (( r >= 0 && r < ROWS && c >= 0 && c < COLS )); do
    case $direction in
      up)
        [[ ${up[$r]:$c:1} == $path ]] && (( c != add_block_c )) && echo $add_block_r,$add_block_c && return
        up[$r]=${up[$r]:0:$c}${path}${up[$r]:$((c+1))}
        if [[ ${grid[$((r-1))]:$c:1} == $block ]]; then
          direction=right
        else
          ((r--))
        fi
        ;;
      right)
        [[ ${right[$r]:$c:1} == $path ]] && (( r != add_block_r )) && echo $add_block_r,$add_block_c && return
        right[$r]=${right[$r]:0:$c}${path}${right[$r]:$((c+1))}
        if [[ ${grid[$r]:$((c+1)):1} == $block ]]; then
          direction=down
        else
          ((c++))
        fi
        ;;
      down)
        [[ ${down[$r]:$c:1} == $path ]] && (( c != add_block_c )) && echo $add_block_r,$add_block_c && return
        down[$r]=${down[$r]:0:$c}${path}${down[$r]:$((c+1))}
        if [[ ${grid[$((r+1))]:$c:1} == $block ]]; then
          direction=left
        else
          ((r++))
        fi
        ;;
      left)
        [[ ${left[$r]:$c:1} == $path ]] && (( r != add_block_r )) && echo $add_block_r,$add_block_c && return
        left[$r]=${left[$r]:0:$c}${path}${left[$r]:$((c+1))}
        if [[ ${grid[$r]:$((c-1)):1} == $block ]]; then
          direction=up
        else
          ((c--))
        fi
        ;;
    esac
  done
  return 1
}

while (( r >= 0 && r < ROWS && c >= 0 && c < COLS )); do
  #grid[$r]=${grid[$r]:0:$c}${path}${grid[$r]:$((c+1))}
  is_loop $r $c $direction &
  case $direction in
    up)
      #up[$r]=${up[$r]:0:$c}${path}${up[$r]:$((c+1))}
      if [[ ${grid[$((r-1))]:$c:1} == $block ]]; then
        direction=right
      else
        ((r--))
      fi
      ;;
    right)
      #right[$r]=${right[$r]:0:$c}${path}${right[$r]:$((c+1))}
      if [[ ${grid[$r]:$((c+1)):1} == $block ]]; then
        direction=down
      else
        ((c++))
      fi
      ;;
    down)
      #down[$r]=${down[$r]:0:$c}${path}${down[$r]:$((c+1))}
      if [[ ${grid[$((r+1))]:$c:1} == $block ]]; then
        direction=left
      else
        ((r++))
      fi
      ;;
    left)
      #left[$r]=${left[$r]:0:$c}${path}${left[$r]:$((c+1))}
      if [[ ${grid[$r]:$((c-1)):1} == $block ]]; then
        direction=up
      else
        ((c--))
      fi
      ;;
  esac
done | sort -u | wc -l


echo Answer: 2165
echo "Bad:    2303"