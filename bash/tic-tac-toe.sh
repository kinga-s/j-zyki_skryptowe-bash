#!/bin/bash

direction_table=([0]="1" [1]="2" [2]="3" [3]="4" [4]="5" [5]="6" [6]="7" [7]="8" [8]="9")
table=([0]=" " [1]=" " [2]=" " [3]=" " [4]=" " [5]=" " [6]=" " [7]=" " [8]=" ")
file="tic-tac-toe.txt"
j=0

make_direction_table() {
    echo "${direction_table[6]} | ${direction_table[7]} | ${direction_table[8]}"
    echo "___________"
    echo "${direction_table[3]} | ${direction_table[4]} | ${direction_table[5]}"
    echo "___________"
    echo "${direction_table[0]} | ${direction_table[1]} | ${direction_table[2]}"
}

make_table() {
    echo "${table[6]} | ${table[7]} | ${table[8]}"
    echo "___________"
    echo "${table[3]} | ${table[4]} | ${table[5]}"
    echo "___________"
    echo "${table[0]} | ${table[1]} | ${table[2]}"
}

is_end() {
  make_table
  for i in {0..2}; do
    if [ "${table[((i*3))]}" == "$1" ] && [ "${table[((i*3+1))]}" == "$1" ] && [ "${table[((i*3+2))]}" == "$1" ]; then
      echo "Player $1 won"
      make_exit
    elif [ "${table[((i))]}" == "$1" ] && [ "${table[((i+3))]}" == "$1" ] && [ "${table[((i+6))]}" == "$1" ]; then
      echo "Player $1 won"
      make_exit
    fi
  done
  if [ "${table[0]}" == "$1" ] && [ "${table[4]}" == "$1" ] && [ "${table[8]}" == "$1" ]; then
    echo "Player $1 won"
    make_exit
  fi
  if [ "${table[2]}" == "$1" ] && [ "${table[4]}" == "$1" ] && [ "${table[6]}" == "$1" ]; then
    echo "Player $1 won"
    make_exit
  fi
}

choose() {
    read -rp "Choose the field $1: " field
    if [[ "$field" == "save" ]]; then
        write_to_file
        exit 0
    fi
    if [[ "$field" =~ ^[1-9]$ ]] && [ "${table[$((field-1))]}" != "X" ] && [ "${table[$((field-1))]}" != "O" ]; then
      table[$((field-1))]=$1
    else
      echo "Wrong field has been selected."
      choose "$1"
    fi
}

delete_file_if_exists(){
    if [ -f "$file" ]; then
      rm -f "$file"
    fi
}

write_to_file() {
    delete_file_if_exists
    for ((i=0; i<9; i++)); do
      echo "${table[$i]}" >> "$file"
    done
}

read_from_file() {
    local i=0
    while read -r line; do
      table["$i"]="$line"
      if [[ "$line" == "X" || "$line" == "O" ]]; then
        ((j++))
      fi
      ((i++))
    done < "$file"
}

make_exit(){
  delete_file_if_exists
  sleep 20
  exit 0
}

make_random_move(){
  random_number=$(( RANDOM % 9 ))
  while [[ "${table[$random_number]}" == "O" || "${table[$random_number]}" == "X" ]]; do
    random_number=$(( RANDOM % 9 ))
  done
  table[$random_number]="X"
}

if [ -f "$file" ]; then
    read -rp "Continue the game? (yes/no): " continue
    if [[ "$continue" == "y" || "$continue" == "Y" || "$continue" == "yes" ]]; then
        read_from_file
    fi
fi

echo "Tic-tac-toe game. The board below presents which field has what number: (like on a numeric keyboard)"
make_direction_table
echo "Let's start the game! If you write 'save' instead of number, the game will save itself and end on a current step"
make_table
while ((j<9)); do
    if ((j%2==0)); then
      choose "O"
      is_end "O"
    else
      echo "Opponent move:"
      make_random_move
      is_end "X"
    fi
    ((j++))
done
echo "Nobody won :("
make_exit
