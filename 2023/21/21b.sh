#!/bin/bash
input=21.input

RE='[.S]'
readarray -t grid < $input
row=$(grep -n S $input)
row=$(( ${row%:*} - 1 ))
col=${grid[$row]%S*}
col=${#col}
max_row=${#grid[@]}
max_col=${#grid[0]}

check() {
  local r=$1
  local c=$2
  local r_mod=$(( r % max_row ))
  (( r_mod < 0 )) && r_mod=$(( max_row + $r_mod ))
  local c_mod=$(( c % max_col ))
  (( c_mod < 0 )) && c_mod=$(( max_col + $c_mod ))
  
  [[ ${grid[$r_mod]:$c_mod:1} =~ $RE ]] && return 0 || return 1
}

gardens_check=" $row,$col "
gardens_even=$gardens_check
gardens_odd=
for (( i=1; i <= ${1:-26501365}; i++ )); do
  # start=$(date +%s%3N)
  (( i % 2 == 0 )) && gardens=$gardens_even || gardens=$gardens_odd
  # one=$(date +%s%3N)
  gardens_new=
  for garden in $gardens_check; do
    read r c <<< ${garden//,/ }
    check $((r-1)) $c && gardens_new+=" $((r-1)),$c "$'\n'
    check $((r+1)) $c && gardens_new+=" $((r+1)),$c "$'\n'
    check $r $((c-1)) && gardens_new+=" $r,$((c-1)) "$'\n'
    check $r $((c+1)) && gardens_new+=" $r,$((c+1)) "$'\n'
  done
  # two=$(date +%s%3N)
  gardens_new=$(sort -u <<< $gardens_new)
  # three=$(date +%s%3N)
  gardens_check=$(comm -13 <(echo "$gardens") <(echo "$gardens_new"))
  # four=$(date +%s%3N)
  gardens=$(sort -u <<< "$gardens
${gardens_check}")
  # five=$(date +%s%3N)
  (( i % 2 == 0 )) && gardens_even=$gardens || gardens_odd=$gardens
  # six=$(date +%s%3N)
  # echo "$i:$(wc -w <<< $gardens):$(wc -w <<< $gardens_check):$(( six - start)):--:$(( one - start )):$(( two - one )):$(( three - two )):$(( four - three ))::$(( five - four ))::$(( six - five ))"|column -t -s:
  echo "$i: $(wc -w <<< $gardens): $(wc -w <<< $gardens_check)"
done

wc -w <<< $gardens