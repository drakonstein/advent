#!/bin/bash

declare -A adj
declare -A path
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
col=${grid[38]%S*}
col=${#col}

adj[N]=${grid[$(( row - 1 ))]:$col:1}
adj[S]=${grid[$(( row + 1 ))]:$col:1}
adj[E]=${grid[$row]:$(( col + 1 )):1}
adj[W]=${grid[$row]:$(( col - 1 )):1}

for i in N S E W; do
  if [[ ${adj[$i]} =~ ${path[$i]} ]]; then
    next=${path[$i[${adj[$i]}]]}
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
while [[ ${grid[$row]:$col:1} != S ]]; do
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

echo $((count/2))
echo Answer: 7086

unset grid
unset adj
unset path
