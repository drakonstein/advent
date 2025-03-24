#!/bin/bash

sum=0
re='[[:digit:]]|one|two|three|four|five|six|seven|eight|nine'
while read line; do
  if [[ $line =~ (${re}).*?(${re}) ]]; then
    number=${BASH_REMATCH[1]}${BASH_REMATCH[2]}
  elif [[ $line =~ ${re} ]]; then
    number=$BASH_REMATCH$BASH_REMATCH
  else
    number=0
  fi
  number=${number//one/1}; number=${number//two/2}
  number=${number//three/3}; number=${number//four/4}
  number=${number//five/5}; number=${number//six/6}
  number=${number//seven/7}; number=${number//eight/8}
  number=${number//nine/9}
  ((sum+=number))
done < 1.input
echo $sum

echo Answer: 55701
