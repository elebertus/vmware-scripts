#!/bin/bash
IFS=,
while read vm lun host bar; do
  snapnew=$(vmware-cmd --server $host --credstore $CS /vmfs/volumes/$lun/$vm/$vm.vmx createsnapshot Clone "Hot Clone" 1 0 | awk '{print $NF}')
  if [[ "$snapnew" -eq "1" ]]; then
    touch /tmp/$vm.snap
  fi
done < $1
