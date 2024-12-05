#!/bin/bash

while read line; do
  if [[ ${line} =~ ^Time:([[:digit:] ]+) ]]; then
    times=(${BASH_REMATCH[1]})
  elif [[ ${line} =~ ^Distance:([[:digit:] ]+) ]]; then
    distances=(${BASH_REMATCH[1]})
  fi
done < 6.input

total=1
for i in ${!times[@]}; do
  (( ${times[$i]} % 2 == 1 )) && is_odd=true || is_odd=false
  time=${times[$i]}
  median=$(( $time / 2 ))
  fastest=$(( median * ( time - median ) ))
  record=${distances[$i]}
  if (( record > fastest )); then
    echo "Impossible--time: $time; record: $record"
    continue
  fi

  n=$(( median / 2 ))
  diff=$(( median - n ))
  i=0
  while true; do
    ((i++))
    test_time=$(( n * ( time - n ) ))
    adjacent_time=$(( ( n - 1 ) * ( time - n + 1 ) ))
    (( diff != 1 )) && (( diff /= 2 ))
    if (( test_time == record )); then
      ((n++))
      break
    elif (( test_time < record )); then
      (( n += diff ))
    else
      if (( adjacent_time <= record )); then
        break
      else
        (( n -= diff ))
      fi
    fi
  done
  echo $i

  count=$(( test_time - adjacent_time ))
  (( total*=count ))
done
echo $total

echo Answer: 1312850
