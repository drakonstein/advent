#!/bin/bash

readarray -t grid < 11.input
re='([[:digit:]]+),([[:digit:]]+)'

for row in ${!grid[@]}; do
  [[ -z "${grid[$row]}" ]] && continue
  [[ ${grid[$row]} =~ \# ]] || expanded_rows+="$row "
  for (( col=0; col < ${#grid[0]}; col++ )); do
    [[ ${grid[$row]:$col:1} == \# ]] && universe+=( "$row,$col" )
  done
done

cols=${universe[@]#*,}
cols=^${cols// /$\|^}$
for (( col=0; col < ${#grid[0]}; col++ )); do
  [[ "${grid[0]:$col:1}" =~ [.#] ]] || continue
  [[ $col =~ $cols ]] || expanded_cols+="$col "
done

find_distance() {
  local one=$1
  local two=$2
  [[ $one =~ $re ]] || return
  local one_row=${BASH_REMATCH[1]}
  local one_col=${BASH_REMATCH[2]}
  [[ $two =~ $re ]] || return
  local two_row=${BASH_REMATCH[1]}
  local two_col=${BASH_REMATCH[2]}

  if (( one_row > two_row )); then
    local row_one=$one_row
    local row_two=$two_row
  else
    local row_one=$two_row
    local row_two=$one_row
  fi
  local row_diff=$(( row_one - row_two ))
  for expanded_row in $expanded_rows; do
    if (( row_one > expanded_row )); then
      if (( expanded_row > row_two )); then
        ((row_diff++))
      fi
    else
      break
    fi
  done

  if (( one_col > two_col )); then
    col_one=$one_col
    col_two=$two_col
  else
    col_one=$two_col
    col_two=$one_col
  fi
  local col_diff=$(( col_one - col_two ))
  for expanded_col in $expanded_cols; do
    if (( col_one > expanded_col )); then
      if (( expanded_col > col_two )); then
        ((col_diff++))
      fi
    else
      break
    fi
  done

  echo $(( row_diff + col_diff ))
}

distances=$(for one in ${!universe[@]}; do
  for (( two=$(( one + 1 )); two < ${#universe[@]}; two++ )); do
    find_distance ${universe[$one]} ${universe[two]} &
  done
  wait
done)

awk '{sum+=$1} END{print sum}' <<< $distances
echo Answer: 9418609

unset grid
unset universe