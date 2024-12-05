#!/bin/bash

input=5.input
declare -a print_before print_after

while read b a; do
  print_before[$b]+=" $a "
  #print_after[$a]+=" $b "
done <<< $(awk -F'|' '/\|/ {print $1,$2}' $input)

is_sorted() {
  local line=( $@ )
  local printed=
  for i in ${!line[@]}; do
    n=${line[$i]}
    if [[ -n "${print_before[$n]}" ]]; then
      for p in $printed; do
        if [[ ${print_before[$n]} =~ " $p " ]]; then
          echo $i
          return 1
        fi
      done
    fi
    printed+=" $n "
  done
}

while read -a line; do
 (
  altered=false
  i=$(is_sorted ${line[@]})
  ret=$?
  while (( ret != 0 )); do
    altered=true
    temp=${line[$i]}
    line[$i]=${line[$((i-1))]}
    line[$((i-1))]=$temp
    i=$(is_sorted ${line[@]})
    ret=$?
  done
  $altered && echo ${line[$((${#line[@]}/2))]}
 ) &
done <<< $(grep -Ev '^$|\|' $input | tr ',' ' ') | awk '{total+=$1}END{print total}'

echo Answer: 4713