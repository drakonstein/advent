#!/bin/bash

input=3.input
sum=0

mults=$(tr '\n' ' ' < $input | sed "s/do()/\n/g;s/don't().*$//mg" | grep -Eo 'mul\([[:digit:]]{1,3},[[:digit:]]{1,3}\)')

for mult in $mults; do
  [[ $mult =~ ([[:digit:]]{1,3}),([[:digit:]]{1,3}) ]]
  ((sum+=${BASH_REMATCH[1]}*${BASH_REMATCH[2]}))
done

echo "$sum"
echo Answer: 83595109