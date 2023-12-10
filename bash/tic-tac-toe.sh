#!/bin/bash

direction_table=([0]="1" [1]="2" [2]="3" [3]="4" [4]="5" [5]="6" [6]="7" [7]="8" [8]="9")

table=([0]=" " [1]=" " [2]=" " [3]=" " [4]=" " [5]=" " [6]=" " [7]=" " [8]=" ")

make_direction_table() {
    echo "${direction_table[6]} | ${direction_table[7]} | ${direction_table[8]}"
    echo "_____________"
    echo "${direction_table[3]} | ${direction_table[4]} | ${direction_table[5]}"
    echo "_____________"
    echo "${direction_table[0]} | ${direction_table[1]} | ${direction_table[2]}"
}

make_table() {
    echo "${table[6]} | ${table[7]} | ${table[8]}"
    echo "_____________"
    echo "${table[3]} | ${table[4]} | ${table[5]}"
    echo "_____________"
    echo "${table[0]} | ${table[1]} | ${table[2]}"
}

is_end() {
  make_table
  for i in {0..2}; do
    if [ "${table[((i*3))]}" == "$1" ] && [ "${table[((i*3+1))]}" == "$1" ] && [ "${table[((i*3+2))]}" == "$1" ]; then
      echo "Gracz $1 wygrał"
      sleep 20
      exit 0
    elif [ "${table[((i))]}" == "$1" ] && [ "${table[((i+3))]}" == "$1" ] && [ "${table[((i+6))]}" == "$1" ]; then
      echo "Gracz $1 wygrał"
      sleep 20
      exit 0
    fi
  done
  if [ "${table[0]}" == "$1" ] && [ "${table[4]}" == "$1" ] && [ "${table[8]}" == "$1" ]; then
    echo "Gracz $1 wygrał"
    sleep 20
    exit 0
  fi
  if [ "${table[2]}" == "$1" ] && [ "${table[4]}" == "$1" ] && [ "${table[6]}" == "$1" ]; then
    echo "Gracz $1 wygrał"
    sleep 20
    exit 0
  fi
}

choose() {
    read -p "Wybierz pole dla $1: " field
    if [[ "$field" =~ ^[1-9]$ ]] && [ "${table[$((field-1))]}" != "X" ] && [ "${table[$((field-1))]}" != "O" ]; then
      table[$((field-1))]=$1
    else
      echo "Wybrano złe pole."
      choose $1
    fi
}

echo "Gra w kółko i krzyżyk. Poniższa plansza prezentuje które pole ma jaki numer: (tak jak na klawiaturze numerycznej)"
make_direction_table
echo "Czas zacząć grę!"
make_table
for i in {0..8}; do
    if ((i%2==0)); then
      choose "O"
      is_end "O"
    else
      choose "X"
      is_end "X"
    fi
done
echo "Nikt nie wygrał :("
sleep 20
exit 0
