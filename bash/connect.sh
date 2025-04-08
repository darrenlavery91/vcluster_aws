#!/bin/bash

# Check if vcluster is installed
echo "Checking if vcluster is installed..."
if ! command -v vcluster &> /dev/null; then
  echo "vcluster could not be found. Please install it first."
  exit 1
fi

# List vclusters and get the name of the first cluster
echo "Fetching vcluster list..."
vclustername=$(vcluster list | awk 'NR>3 {print $1}' | head -n 1)

# Check if vcluster name is found
if [ -z "$vclustername" ]; then
  echo "No vcluster found. Exiting."
  exit 1
fi

echo "Connecting to vcluster: $vclustername..."

# Connect to vcluster in the background
nohup vcluster connect $vclustername > vcluster_output.log 2>&1 &

echo "vcluster connect is running in the background. Check vcluster_output.log for details."