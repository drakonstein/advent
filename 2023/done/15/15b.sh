#!/bin/bash

declare -A map=( ["a"]=97 ["b"]=98 ["c"]=99 ["d"]=100 ["e"]=101 ["f"]=102 ["g"]=103 ["h"]=104 ["i"]=105 ["j"]=106 ["k"]=107 ["l"]=108 ["m"]=109 ["n"]=110 ["o"]=111 ["p"]=112 ["q"]=113 ["r"]=114 ["s"]=115 ["t"]=116 ["u"]=117 ["v"]=118 ["w"]=119 ["x"]=120 ["y"]=121 ["z"]=122 )
declare -a boxes

sum=0
while read step; do
  [[ -z "$step" ]] && continue
  box=0
  for (( n=0; n<${#step}; n++ )); do
    [[ ${step:$n:1} =~ [a-z] ]] || break
    ((box+=map[${step:$n:1}]))
    ((box*=17))
    ((box%=256))
  done
  label=${step:0:$n}
  [[ ${boxes[$box]} =~ \ +$label\  ]] && matched=true || matched=false
  case ${step:$n:1} in
    -)
      $matched && boxes[$box]=$(grep -v "^ $label " <<< ${boxes[$box]})
    ;;
    =)
      focal=${step:$((n+1))}
      if $matched; then
        boxes[$box]=$(sed "/^ $label /c \ $label $focal" <<< ${boxes[$box]})
      else
        # using a space before and after the label for easy matching
        boxes[$box]+=$'\n'" $label $focal"
      fi
    ;;
  esac
done <<< $(tr ',' '\n' < 15.input)

sum=0
for n in ${!boxes[@]}; do
  slot=1
  while read label focal; do
    [[ -z "$label" ]] && continue
    ((sum+=(n+1)*slot++*focal))
  done <<< ${boxes[$n]}
done

echo $sum
echo Answer: 269410