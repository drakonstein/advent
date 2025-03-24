#!/bin/bash

declare -a five
declare -a four
declare -a full
declare -a three
declare -a twopair
declare -a pair
declare -a junk
count=0
total=0

while read hand bet; do
  [[ $hand =~ ^([0-9TJQKA])([0-9TJQKA])([0-9TJQKA])([0-9TJQKA])([0-9TJQKA])$ ]] || continue
  ((count++))
  hand=${BASH_REMATCH[@]:1:5}
  hand=${hand//T/10}
  hand=${hand//J/1}
  hand=${hand//Q/12}
  hand=${hand//K/13}
  hand=${hand//A/14}
  quality=$(awk 'BEGIN {RS=" "} {if($1=="1") { ++joker } else { ++count[$1] }} END { for(k in count) { if(count[k]>most) { second=most; most=count[k]} else if(count[k]>second) { second=count[k] }} most = most + joker; print most,second}' <<< "$hand")
  case $quality in
  "5 ")
    five+=( "$hand $bet" )
    ;;
  "4 1")
    four+=( "$hand $bet" )
    ;;
  "3 2")
    full+=( "$hand $bet" )
    ;;
  "3 1")
    three+=( "$hand $bet" )
    ;;
  "2 2")
    twopair+=( "$hand $bet" )
    ;;
  "2 1")
    pair+=( "$hand $bet" )
    ;;
  "1 1")
    junk+=( "$hand $bet" )
    ;;
  esac
done < 7.input

IFS=$'\n'
sorted=($(sort -nrk1 -k2 -k3 -k4 -k5 <<<"${five[*]}"))
sorted+=($(sort -nrk1 -k2 -k3 -k4 -k5 <<<"${four[*]}"))
sorted+=($(sort -nrk1 -k2 -k3 -k4 -k5 <<<"${full[*]}"))
sorted+=($(sort -nrk1 -k2 -k3 -k4 -k5 <<<"${three[*]}"))
sorted+=($(sort -nrk1 -k2 -k3 -k4 -k5 <<<"${twopair[*]}"))
sorted+=($(sort -nrk1 -k2 -k3 -k4 -k5 <<<"${pair[*]}"))
sorted+=($(sort -nrk1 -k2 -k3 -k4 -k5 <<<"${junk[*]}"))

for i in ${!sorted[@]}; do
  [[ ${sorted[$i]} =~ ([[:digit:]]+)$ ]] || continue
  ((total+=count * $BASH_REMATCH))
  ((count--))
done
echo $total

unset five
unset four
unset full
unset three
unset twopair
unset pair
unset junk
unset sorted

echo Answer: 249400220
