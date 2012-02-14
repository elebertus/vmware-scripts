#!/bin/bash
IFS=,
if [[ -z $1 ]]; then
  echo "Please provide an input file"
  exit 1
else
  while read vm lun host bar; do
    scp user@$host:/vmfs/volumes/$lun/$vm/$vm.vmx .
  done < $1
fi
