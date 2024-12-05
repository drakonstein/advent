#!/bin/bash

input=3.input
sum=0

mults=$(grep -Eo 'mul\([[:digit:]]{1,3},[[:digit:]]{1,3}\)' $input)

for mult in $mults; do
  [[ $mult =~ ([[:digit:]]{1,3}),([[:digit:]]{1,3}) ]]
  ((sum+=${BASH_REMATCH[1]}*${BASH_REMATCH[2]}))
done

echo $sum
echo Answer: 161289189