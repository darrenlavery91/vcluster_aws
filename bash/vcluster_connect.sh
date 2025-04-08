#!/bin/bash
# check out: https://medium.com/p/5e7057744bcc/edit
# Get the list of vcluster names
vclusters=$(vcluster list | awk 'NR>3 {print $1}')

# Check if there are any vclusters listed
if [ -z "$vclusters" ]; then
  echo "No vclusters found."
  exit 1
fi

# Display vclusters and prompt for selection
echo "Available vclusters:"
echo "$vclusters"
echo
echo "Please select a vcluster:"
select vclustername in $vclusters; do
  if [ -n "$vclustername" ]; then
    echo "You selected: $vclustername"
    break
  else
    echo "Invalid selection, please try again."
  fi
done

# Connect to the selected vcluster
echo "Connecting to $vclustername..."
nohup vcluster connect $vclustername > vcluster_output.log 2>&1 &
echo "vcluster connect is running in the background. Check vcluster_output.log for details."

# Output the info of the vcluster
echo "Run `vcluster disconnect` to switch back to the parent context"