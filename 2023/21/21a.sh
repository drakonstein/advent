#!/bin/bash
input=21.input

RE='[.S]'
readarray -t grid < $input
row=$(grep -n S $input)
row=$(( ${row%:*} - 1 ))
col=${grid[$row]%S*}
col=${#col}
max_row=$(( ${#grid[@]} - 1 ))
max_col=$(( ${#grid[0]} - 1 ))

gardens_check=" $row,$col "
gardens_even=$gardens_check
gardens_odd=
for (( i=1; i <= ${1:-64}; i++ )); do
  (( i % 2 == 0 )) && gardens=$gardens_even || gardens=$gardens_odd
  gardens_new=
  for garden in $gardens_check; do
    read r c <<< ${garden//,/ }
    (( r > 0 )) && [[ ${grid[$((r-1))]:$c:1} =~ $RE ]] && gardens_new+=" $((r-1)),$c "
    (( r < max_row )) && [[ ${grid[$((r+1))]:$c:1} =~ $RE ]] && gardens_new+=" $((r+1)),$c "
    (( c > 0 )) && [[ ${grid[$r]:$((c-1)):1} =~ $RE ]] && gardens_new+=" $r,$((c-1)) "
    (( c < max_col )) && [[ ${grid[$r]:$((c+1)):1} =~ $RE ]] && gardens_new+=" $r,$((c+1)) "
  done
  gardens_new=$(sort -u <<< " ${gardens_new// / $'\n' }")
  gardens_check=$(comm -13 <(echo "$gardens") <(echo "$gardens_new"))
  gardens=$(sort -u <<< "$gardens
${gardens_check}")
  (( i % 2 == 0 )) && gardens_even=$gardens || gardens_odd=$gardens
done

#echo "$gardens"
wc -w <<< $gardens
echo Answer: 3637