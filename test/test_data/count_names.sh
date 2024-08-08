#!/bin/bash

# Check if the JSON file is provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <json-file>"
  exit 1
fi

json_file="$1"

# Extract all "Name" values using jq
names=$(jq -r '..|objects|.Name? // empty' "$json_file")

# Count the occurrences of each "Name" value
#echo "$names" | sort | uniq -c | awk '$1 > 1 {print $2}'
echo "$names" | sort | uniq -c | awk '$1 > 1'
