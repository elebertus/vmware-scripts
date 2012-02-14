#!/bin/bash
IFS=,
if [[ -z $1 ]]; then
  echo "Please provide an input file"
  exit 1
else
  while read vm lun host tar bar; do
    if [[ -f /tmp/$vm.snap ]]; then
      vmkfstools --server $host --credstore $CS -i /vmfs/volumes/$lun/$vm/$vm.vmdk /vmfs/volumes/$tar/backup/$vm.CLONE.vmdk
      rm -f /tmp/$vm.snap
    fi
  done < $1
fi
