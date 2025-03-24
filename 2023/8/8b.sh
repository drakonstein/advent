#!/bin/bash

declare -A nodes
max=0

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

while read line; do
  if [[ -z "$line" ]]; then
    continue
  elif [[ $line =~ ^[RL]+$ ]]; then
    instructions=( $(sed 's/./& /g' <<< "$line") )
    max=${#instructions[@]}
  elif [[ $line =~ ^([[:alpha:]]{3})\ =\ \(([[:alpha:]]{3}),\ ([[:alpha:]]{3}) ]]; then
    node=${BASH_REMATCH[1]}
    left=${BASH_REMATCH[2]}
    right=${BASH_REMATCH[3]}
    nodes[$node[L]]=$left
    nodes[$node[R]]=$right
    if [[ $node =~ ..A ]]; then
      starts+="$node "
    elif [[ $node =~ ..Z ]]; then
      reend+="$node|"
    fi
  fi
done < 8.input
reend=${reend::-1}

for start in $starts; do
  count=0
  current=$start
  while true; do
    if [[ $current =~ $reend ]]; then
      counts+="$count "
      break
    fi
    i=${instructions[$(( count % max ))]}
    current=${nodes[$current[$i]]}
    ((count++))
  done
done
counts=${counts::-1}
counts=$(sort -un <<< ${counts// /$'\n'})

lcm $counts

unset instructions
unset nodes

echo Answer: 21083806112641
