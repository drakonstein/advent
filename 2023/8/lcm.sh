#!/bin/bash

if (( $# < 2 )); then
  echo Not enough numbers provided: $@
  exit 1
fi

gcd() {
  local a=$1
  local b=$2
  local diff=$(( a - b ))
  diff=${diff#-}
  if (( a == b )); then
    echo $a
    return
  elif (( a < b )); then
    if (( diff < a )); then
      result=$diff
    else
      result=$a
    fi
  else
    if (( diff < b )); then
      result=$diff
    else
      result=$b
    fi
  fi
  while (( result > 0 )); do
    (( a % result == 0 )) && (( b % result == 0 )) && break
    ((result--))
  done
  echo $result
}

lcm() {
  local a=$1
  shift
  while (( $# > 0 )); do
    local b=$1
    shift
    local GCD=$(gcd $a $b)
    a=$(( a * b / GCD ))
  done
  echo $a
}

nums=$@
nums=$(sort -un <<< ${nums// /$'\n'})
lcm $nums
