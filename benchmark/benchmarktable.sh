#!/bin/bash

# Default value for n
n=44

# Usage function to display help
usage() {
  echo "Usage: $0 [-n number_of_characters] table1.md table2.md"
  exit 1
}

# Parse optional argument
while getopts ":n:" opt; do
  case ${opt} in
    n )
      n=$OPTARG
      ;;
    \? )
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
  usage
fi

# Files
table1=$1
table2=$2

# Extract filenames without extensions for the header
header1=$(basename "$table1" .md)
header2=$(basename "$table2" .md)

# Create the header for the combined table
echo "|                                         | $header1              | $header2              |"
echo '|:----------------------------------------|:------------------:|:------------------:|'

# Combine the data rows, removing the first n characters from the second table
paste -d '|' <(awk 'NR>2' "$table1") <(awk -v n=$n 'NR>2 {print substr($0, n+1)}' "$table2")
