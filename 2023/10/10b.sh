#!/bin/bash

declare -A adj
declare -A path
declare -A edge
path[N]='\||7|F'
path[N[|]]=N
path[N[7]]=W
path[N[F]]=E
path[S]='\||L|J'
path[S[|]]=S
path[S[L]]=E
path[S[J]]=W
path[E]='-|J|7'
path[E[-]]=E
path[E[J]]=N
path[E[7]]=S
path[W]='-|L|F'
path[W[-]]=W
path[W[L]]=N
path[W[F]]=S
readarray -t grid < 10.input
row=$(grep -n S 10.input)
row=$(( ${row%:*} - 1 ))
col=${grid[$row]%S*}
col=${#col}

adj[N]=${grid[$(( row - 1 ))]:$col:1}
adj[S]=${grid[$(( row + 1 ))]:$col:1}
adj[E]=${grid[$row]:$(( col + 1 )):1}
adj[W]=${grid[$row]:$(( col - 1 )):1}

for i in N S E W; do
  if [[ ${adj[$i]} =~ ${path[$i]} ]]; then
    edge[$row[$col]]=true
    case $i in
      N)
        ((row--))
        ;;
      S)
        ((row++))
        ;;
      E)
        ((col++))
        ;;
      W)
        ((col--))
        ;;
    esac
    break
  fi
done
count=1
next=${path[$i[${adj[$i]}]]}
next_orig=$next

while [[ ${grid[$row]:$col:1} != S ]]; do
  edge[$row[$col]]=true
  ((count++))
  case $next in
    N)
      ((row--))
      ;;
    S)
      ((row++))
      ;;
    E)
      ((col++))
      ;;
    W)
      ((col--))
      ;;
  esac
  next=${path[$next[${grid[$row]:$col:1}]]}
done

grid=( ${grid[@]//7/┐} )
grid=( ${grid[@]//F/┌} )
grid=( ${grid[@]//L/└} )
grid=( ${grid[@]//J/┘} )
grid=( ${grid[@]//\|/│} )
grid=( ${grid[@]//-/─} )
grid=( ${grid[@]//S/│} )


for r in ${!grid[@]}; do
  start=false
  for (( c=0; c<${#grid[$r]}; c++ )); do
    if [[ "${edge[$r[$c]]}" == "true" ]]; then
      start=true

      echo -n "${grid[$r]:$c:1}"
    else
      $start && echo -n '*' || echo -n ' '
    fi
  done
  echo
done


unset grid
unset adj
unset path
unset edge
