#!/bin/bash
if [[ -z "$1" ]]; then
  echo "No data source file specified"
  echo
  echo "usage vmdk-hot-backup.sh vm-list"
  echo
  echo "The vm-list file must be a csv file with the following format:"
  echo 
  echo "VM_NAME,4de99237-fce1f0c9-51a2-002264f8b806,esxhost,4e2a21a3-54c4d462-37ce-002264f8b806,40,"
  echo 
  echo "The first field is the VM name in virtual center, second is the UUID of"
  echo "the LUN where the VM is stored, third is the name of the host where the"
  echo "VM is registered, fourth is the UUID of the target LUN where you intend"
  echo "to copy the vmdk file, and the fith is the drive size, but not required"
  exit
fi
IFS=,
while read vm lun host bar; do
  snapnew=$(vmware-cmd --server $host --credstore $CS /vmfs/volumes/$lun/$vm/$vm.vmx createsnapshot Clone "Hot Clone" 1 0 | awk '{print $NF}')
  echo "Creating snapshot for $vm"
  if [[ "$snapnew" -eq "1" ]]; then
    touch /tmp/$vm.snap
  fi
done < $1

while read vm lun host tar bar; do
  if [[ -f /tmp/$vm.snap ]]; then
    echo "Creating a clone of $vm.vmdk"
    vmkfstools --server $host --credstore $CS -i /vmfs/volumes/$lun/$vm/$vm.vmdk /vmfs/volumes/$tar/backup/$vm.CLONE.vmdk
  fi
done < $1

while read vm lun host bar; do
  if [[ -f /tmp/$vm.snap ]]; then
    echo "Removing snapshot for $vm"
    vmware-cmd --server $host --credstore $CS /vmfs/volumes/$lun/$vm/$vm.vmx removesnapshots &> /dev/null
    rm -f /tmp/$vm.snap
  fi
done < $1
