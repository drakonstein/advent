#!/bin/bash
set -f
input=7.test

check_math() {
  args=( $@ )
  local num_args=$#
  local t=$1
  local result=$(bc <<< $2$3$4)
  for (( i=5; i<$num_args; i+=2 )); do
    result=$(( $(bc <<< $result${args[$((i-1))]}${args[$i]}) ))
  done
  echo $num_args - $t: $result
}

while read line; do
  [[ $line =~ ([[:digit:]]+):\ ([[:digit:]\ ]+) ]]
  total=${BASH_REMATCH[1]}
  values=( ${BASH_REMATCH[2]// / + } )
  for (( n=1; n <= $(grep -c + <<< ${values[@]}); n++ )); do

    for (( i=1; i < ${#values[@]}; i+=2 )); do
      check_math $total ${values[@]}
    done
done < $input


set +f