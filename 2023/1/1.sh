#!/bin/bash

sum=0
while read line; do
  if [[ ${line} =~ ([[:digit:]]{1}).*([[:digit:]]{1})+ ]]; then
    number=${BASH_REMATCH[1]}${BASH_REMATCH[2]}
  elif [[ ${line} =~ [[:digit:]] ]]; then
    number=$BASH_REMATCH$BASH_REMATCH
  else
    number=0
  fi
  ((sum+=$number))
done < 1.input
echo $sum

echo Answer: 56397
