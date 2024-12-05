#!/bin/bash

declare -A maps

find_mapping() {
  local source=$1
  local num=$2
  local map=$(grep -Eo "${source}-to-[[:alpha:]]+" <<< ${!maps[@]})
  if [[ -z $map ]]; then
    echo $@
    return
  fi
  local destination=$(cut -d- -f3 <<< $map)
  while read destination_map source_map range; do
    [[ -z "$destination_map" ]] && continue
    if (( num >= source_map && num <= source_map + range - 1 )); then
      num=$(( destination_map + num - source_map ))
      break
    fi
  done <<< "${maps[$map]}"
  find_mapping $destination $num $@
}

while read line; do
  if [[ ${line:0:6} == seeds: ]]; then
    seeds=$(cut -d: -f2 <<< $line)
  elif [[ $line =~ .*\ map:$ ]]; then
    map=$(cut -d' ' -f1 <<< $line)
  elif [[ $line =~ ^[0-9]+\ [0-9]+\ [0-9]+$ ]]; then
    maps[$map]+="$line
"
  fi
done < 5.input

results=$(for seed in $seeds; do echo seed $seed: $(find_mapping seed $seed); done)
sort -nk4 <<< "$results" | head -n1 | awk '{print $1,$2,$3,$4}'
