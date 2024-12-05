#!/bin/bash

declare -A grid
declare -A numbers
declare -A gears
num_count=0
is_num=false
was_num=false
row=0
sum=0

while read line; do
  if $is_num; then
    num_stop=$column
    ((num_count++))
    numbers[$num_count]=$number
    numbers[$num_count['row']]=$row
    numbers[$num_count['start']]=$num_start
    numbers[$num_count['stop']]=$num_stop
    is_num=false
    was_num=false
    number=
  fi
  ((row++))
  column=0
  while read char; do
    ((column++))
    grid[$row[$column]]=$char
    [[ $char =~ [0-9] ]] && is_num=true || is_num=false
    if $is_num; then
      number+=$char
      ! $was_num && num_start=$column
      was_num=true
    elif $was_num; then
      num_stop=$(( column - 1 ))
      ((num_count++))
      numbers[$num_count]=$number
      numbers[$num_count['row']]=$row
      numbers[$num_count['start']]=$num_start
      numbers[$num_count['stop']]=$num_stop
      was_num=false
      number=
    fi
  done <<< $(echo "$line" | grep -Eo .)
done < 3.input

for (( n=0; n<=$num_count; n++ )); do
  number=${numbers[$n]}
  row=${numbers[$n['row']]}
  num_start=${numbers[$n['start']]}
  num_stop=${numbers[$n['stop']]}
  match=false
  for (( r=$((row-1)); r<=$((row+1)); r++ )); do
    for (( c=$((num_start-1)); c<=$((num_stop+1)); c++ )); do
      char=${grid[$r[$c]]}
      [[ "$char" != "*" ]] && continue
      ((gears[$r[$c['count']]]++))
      [[ -z ${gears[$r[$c['ratio']]]} ]] && gears[$r[$c['ratio']]]=$number || ((gears[$r[$c['ratio']]]*=$number))
    done
  done
done

for key in $(echo ${!gears[@]} | grep count); do
  (( ${gears[$key]:-0} != 2 )) && continue
  ratio_key=${key/count/ratio}
  ((sum+=${gears[$ratio_key]}))
done

echo $sum
unset grid
unset numbers
unset gears
