#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <investment_vnd> <buy_price_usd> <sell_price_usd> <exchange_rate>"
  exit 1
fi

# Read input arguments
investment_vnd=$1
buy_price_usd=$2
sell_price_usd=$3
exchange_rate=$4

# Calculate the amount of coins bought
coins_bought=$(echo "scale=10; $investment_vnd / ($buy_price_usd * $exchange_rate)" | bc)

# Calculate the total sell value in VND
sell_value_vnd=$(echo "scale=2; $coins_bought * $sell_price_usd * $exchange_rate" | bc)

# Calculate the profit
earn=$(echo "scale=2; $sell_value_vnd - $investment_vnd" | bc)

# Format the output using awk for thousands separator
formatted_earn=$(echo "$earn" | awk '{printf "%\047.2f", $1}')

echo "Your earnings: ${formatted_earn} VND"
