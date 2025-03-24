#!/bin/bash

readarray -t grid < 14.input
# 84 times through the sorting creates a loop 93 iterations long
# ((1000000000 - 84) % 93) + 84 = 109 loops to run to get the answer
loops=${i:-109}

north() {
  for (( c=0; c<${#grid[0]}; c++ )); do
    row=0
    for (( r=0; r<${#grid[@]}; r++ )); do
      case ${grid[$r]:$c:1} in
        O)
          if (( row != r )); then
            if (( c == 0 )); then
              grid[$row]=O${grid[$row]:1}
              grid[$r]=.${grid[$r]:1}
            elif (( c == 1 )); then
              grid[$row]=${grid[$row]:0:1}O${grid[$row]:2}
              grid[$r]=${grid[$r]:0:1}.${grid[$r]:2}
            else
              grid[$row]=${grid[$row]:0:c}O${grid[$row]:$((c+1))}
              grid[$r]=${grid[$r]:0:c}.${grid[$r]:$((c+1))}
            fi
          fi
          ((row++))
          ;;
        \#)
          row=$(( r + 1 ))
          ;;
        .)
          ;;
      esac
    done
  done
}

south() {
  for (( c=0; c<${#grid[0]}; c++ )); do
    row=$(( ${#grid[@]} - 1 ))
    for (( r=row; r>=0; r-- )); do
      case ${grid[$r]:$c:1} in
        O)
          if (( row != r )); then
            if (( c == 0 )); then
              grid[$row]=O${grid[$row]:1}
              grid[$r]=.${grid[$r]:1}
            elif (( c == 1 )); then
              grid[$row]=${grid[$row]:0:1}O${grid[$row]:2}
              grid[$r]=${grid[$r]:0:1}.${grid[$r]:2}
            else
              grid[$row]=${grid[$row]:0:c}O${grid[$row]:$((c+1))}
              grid[$r]=${grid[$r]:0:c}.${grid[$r]:$((c+1))}
            fi
          fi
          ((row--))
          ;;
        \#)
          row=$(( r - 1 ))
          ;;
        .)
          ;;
      esac
    done
  done
}

west() {
  for r in ${!grid[@]}; do
    col=0
    for (( c=0; c<${#grid[0]}; c++ )); do
      case ${grid[$r]:$c:1} in
        O)
          if (( col != c )); then
            grid[$r]=${grid[$r]:0:$col}O${grid[$r]:$((col+1)):$((c-col-1))}.${grid[$r]:$((c+1))}
          fi
          ((col++))
          ;;
        \#)
          col=$(( c + 1 ))
          ;;
        .)
          ;;
      esac
    done
  done
}

east() {
  for r in ${!grid[@]}; do
    col=$(( ${#grid[0]} - 1 ))
    for (( c=col; c>=0; c-- )); do
      case ${grid[$r]:$c:1} in
        O)
          if (( col != c )); then
            grid[$r]=${grid[$r]:0:$c}.${grid[$r]:$((c+1)):$((col-c-1))}O${grid[$r]:$((col+1))}
          fi
          ((col--))
          ;;
        \#)
          col=$(( c - 1 ))
          ;;
        .)
          ;;
      esac
    done
  done
}

for (( i=1; i<=$loops; i++)); do
  north
  west
  south
  east
  #echo $i: $(md5sum <<< ${grid[@]})
  #md5sum <<< ${grid[@]}
done

mult=${#grid[@]}

sum=0
for row in ${!grid[@]}; do
  ((sum+=mult--*$(grep -Eo O <<< ${grid[$row]} | wc -l)))
done

echo $sum

echo Answer: 95736