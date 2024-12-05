#!/bin/bash

good=.
broken=#
unknown=?

sum=0
while read springs seq; do
  [[ -z "$springs" ]] || [[ -z "$seq" ]] && continue
  count=0
  seq=${seq//,/ }
  echo $springs $seq
  echo ${#springs}
  for (( i=0; i<${#springs}; i++ )); do
    for s in $seq; do
      
    done
    echo ${springs:$i:1}
  done
  in_break=false

  ((sum+=count))
  exit
done < 12.testa

echo $sum
echo Answer: 6