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

gardens=$row,$col
for (( i=0; i < ${1:-64}; i++ )); do
  plots=
  wc -w <<< $gardens
  time for garden in $gardens; do
    read r c <<< ${garden//,/ }
    (( r > 0 )) && [[ ${grid[$((r-1))]:$c:1} =~ $RE ]] && plots+=" $((r-1)),$c"
    (( r < max_row )) && [[ ${grid[$((r+1))]:$c:1} =~ $RE ]] && plots+=" $((r+1)),$c"
    (( c > 0 )) && [[ ${grid[$r]:$((c-1)):1} =~ $RE ]] && plots+=" $r,$((c-1))"
    (( c < max_col )) && [[ ${grid[$r]:$((c+1)):1} =~ $RE ]] && plots+=" $r,$((c+1))"
  done
  gardens=$(sort -Vu <<< ${plots// /$'\n'})
done

#echo "$gardens"
wc -w <<< $gardens
echo Answer: 3637