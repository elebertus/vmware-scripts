#!/bin/bash
IFS=,
if [[ -z $1 ]]; then
  echo "Please provide an input file"
  exit 1
else
  while read vm lun host bar; do
    snap=$(vmware-cmd --server $host --credstore $CS /vmfs/volumes/$lun/$vm/$vm.vmx hassnapshot | awk '{print $NF}')
    if [[ "$snap" -eq "1" ]]; then
      echo "$vm has a snapshot"
    fi
  done < $1
fi
