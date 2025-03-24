#!/bin/bash

declare -A maps

find_mapping() {
  local source=$1
  local start=$2
  local end=$3
  local map=$(grep -Eo "${source}-to-[[:alpha:]]+" <<< ${!maps[@]})
  if [[ -z $map ]]; then
    echo $@
    return
  fi
  local destination=$(cut -d- -f3 <<< $map)

  local finished=false
  while read destination_map start_map range; do
    [[ -z "$range" ]] && continue
    local end_map=$(( start_map + range - 1 ))
    if (( end < start_map )); then
      break
    elif (( start >= start_map && start <= end_map )); then
      local diff=$(( start - start_map ))
      local new_start=$(( destination_map + diff ))
      if (( end <= end_map )); then
        local diff2=$(( end - start ))
        local new_end=$(( new_start + diff2 ))
        finished=true
        find_mapping $destination $new_start $new_end $@
        break
      else
        local diff2=$(( end_map - start ))
        local new_end=$(( new_start + diff2 ))
        find_mapping $destination $new_start $new_end $@ &
        start=$(( end_map + 1 ))
      fi
    elif (( end >= start_map && end <= end_map )); then
      local diff=$(( end - start_map ))
      local new_start=$destination_map
      local new_end=$(( new_start + diff ))
      find_mapping $destination $new_start $new_end $@ &
      end=$(( start_map - 1 ))
    fi
  done <<< "$(sort -nk2 <<< ${maps[$map]})"
  ! $finished && find_mapping $destination $start $end $@
}

while read line; do
  if [[ ${line:0:6} == seeds: ]]; then
    seedranges=$(cut -d: -f2 <<< $line | grep -Eo '[[:digit:]]+ [[:digit:]]+')
  elif [[ $line =~ .*\ map:$ ]]; then
    map=$(cut -d' ' -f1 <<< $line)
  elif [[ $line =~ ^[0-9]+\ [0-9]+\ [0-9]+$ ]]; then
    maps[$map]+="$line
"
  fi
done < 5.input

output=$(while read start range; do find_mapping seed $start $(( start + range - 1 ))& done <<< "$seedranges"; wait)
sort -nk2 <<< "$output" | head -n1 | awk '{print $2}'

unset maps
