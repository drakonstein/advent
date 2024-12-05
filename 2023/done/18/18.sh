#!/bin/bash

declare -a points
c=0
r=0

perimeter=0
while read direction count color; do
  [[ -z "$direction" ]] && continue
  ((perimeter+=count))
  points+=( "$r $c" )
  case $direction in
    R)
      ((c+=count))
      ;;
    L)
      ((c-=count))
      ;;
    D)
      ((r+=count))
      ;;
    U)
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
echo Answer: 62365