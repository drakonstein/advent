#!/bin/bash

declare -A nodes
start=AAA
end=ZZZ
max=0
count=0

while read line; do
  if [[ -z "$line" ]]; then
    continue
  elif [[ $line =~ ^[RL]+$ ]]; then
    instructions=( $(sed 's/./& /g' <<< "$line") )
    max=${#instructions[@]}
  elif [[ $line =~ ^([[:alpha:]]{3})\ =\ \(([[:alpha:]]{3}),\ ([[:alpha:]]{3}) ]]; then
    nodes[${BASH_REMATCH[1]}[L]]=${BASH_REMATCH[2]}
    nodes[${BASH_REMATCH[1]}[R]]=${BASH_REMATCH[3]}
  fi
done < 8.input

current=$start
while true; do
  [[ $current == $end ]] && echo $count && break
  i=${instructions[$(( count % max ))]}
  current=${nodes[$current[$i]]}
  ((count++))
done

unset instructions
unset nodes

echo Answer: 21389
