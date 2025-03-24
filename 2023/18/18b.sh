#!/bin/bash

declare -a points
c=0
r=0

perimeter=0
while read direction count color; do
  [[ -z "$color" ]] && continue
  [[ $color =~ ([[:alnum:]]{5})([[:alnum:]]{1}) ]]
  count=$((16#${BASH_REMATCH[1]}))
  direction=${BASH_REMATCH[2]}

  ((perimeter+=count))
  points+=( "$r $c" )
  case $direction in
    0)
      ((c+=count))
      ;;
    2)
      ((c-=count))
      ;;
    1)
      ((r+=count))
      ;;
    3)
      ((r-=count))
      ;;
  esac
done < 18.input

area=0
for p in ${!points[@]}; do
  read r1 c1 <<< ${points[$p]}
  read r2 c2 <<< ${points[$(((p+1)%${#points[@]}))]}
  ((area+=(r1*c2)-(r2*c1)))
done
area=$(awk "BEGIN{print (${area#-} / 2) + ($perimeter / 2 + 1)}")
echo $area
echo Answer: 159485361249806