#!/usr/bin/env bash

set -e

BALANCE=$(seth --to-wei "$1" "eth")

FACTORY=0x2fDbAdf3C4D5A8666Bc06645B8358ab803996E28

SUPPLY=$(seth call "$FACTORY" 'totalSupply()(uint256)')

while IFS=$'\n' read -r line; do data+=("$line"); done < <(seth call "$FACTORY" 'getReserves()(uint112,uint112,uint32)')
YFI=${data[0]}
WETH=${data[1]}

WAD=$(seth --to-wei 1 "eth")
SHARE=$(echo "$BALANCE * $WAD / $SUPPLY" | bc)

echo "SHARE: $(bc -l <<< "scale=27; ($SHARE / $WAD) * 100")%"

echo "YFI: $(seth --from-wei "$(echo "$YFI * $SHARE / $WAD" | bc)")"

echo "WETH: $(seth --from-wei "$(echo "$WETH * $SHARE / $WAD" | bc)")"
