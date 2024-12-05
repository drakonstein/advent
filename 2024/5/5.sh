#!/bin/bash

input=5.input
declare -a print_before
#declare -a print_after

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
          return 1
        fi
      done
    fi
    printed+=" $n "
  done
}

while read -a line; do
 (
  is_sorted ${line[@]} && echo ${line[$((${#line[@]}/2))]}
 ) &
done <<< $(grep -Ev '^$|\|' $input | tr ',' ' ') | awk '{total+=$1}END{print total}'

echo Answer: 7307