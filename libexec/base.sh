#!/usr/bin/env bash

set -e

BALANCE=$(seth --to-wei "$1" "eth")

SUPPLY=$(seth call "$PAIR" 'totalSupply()(uint256)')

while IFS=$'\n' read -r line; do data+=("$line"); done < <(seth call "$PAIR" 'getReserves()(uint112,uint112,uint32)')
TOK1=${data[0]}
TOK2=${data[1]}

WAD=$(seth --to-wei 1 "eth")
SHARE=$(echo "$BALANCE * $WAD / $SUPPLY" | bc)


echo "PRICE 1: $(bc -l <<< "scale=27; $TOK1 / $TOK2")"

echo "PRICE 2: $(bc -l <<< "scale=27; $TOK2 / $TOK1")"

echo "SHARE: $(bc -l <<< "scale=27; ($SHARE / $WAD) * 100")%"

echo "$2: $(seth --from-wei "$(echo "$TOK1 * $SHARE / $WAD" | bc)")"

echo "$3: $(seth --from-wei "$(echo "$TOK2 * $SHARE / $WAD" | bc)")"

