#!/bin/bash

while read line; do
  if [[ ${line} =~ ^Time:([[:digit:] ]+) ]]; then
    time=(${BASH_REMATCH[1]// /})
  elif [[ ${line} =~ ^Distance:([[:digit:] ]+) ]]; then
    distance=(${BASH_REMATCH[1]// /})
  fi
done < 6.input

median=$(( $time / 2 ))
fastest=$(( median * ( time - median ) ))
if (( distance > fastest )); then
  echo "Impossible--time: $time; distance: $distance"
  exit 1
fi

n=$(( median / 2 ))
diff=$(( median - n ))
i=0
while true; do
  ((i++))
  test_time=$(( n * ( time - n ) ))
  adjacent_time=$(( ( n - 1 ) * ( time - n + 1 ) ))
  (( diff != 1 )) && (( diff /= 2 ))
  if (( test_time == distance )); then
    ((n++))
    break
  elif (( test_time < distance )); then
    (( n += diff ))
  else
    if (( adjacent_time <= distance )); then
      break
    else
      (( n -= diff ))
    fi
  fi
done

echo $(( test_time - adjacent_time ))
echo Loop counter: $i 
echo Answer: 36749103
