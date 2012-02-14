#!/bin/bash
IFS=,
while read vm lun host bar; do
  if [[ -f /tmp/$vm.snap ]]; then
    vmware-cmd --server $host --credstore $CS /vmfs/volumes/$lun/$vm/$vm.vmx removesnapshots
    rm -f /tmp/$vm.snap
  fi
done < data/mossuid
