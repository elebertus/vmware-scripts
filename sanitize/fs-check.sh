#!/bin/bash
# I run this script from a linux workstation that has the 
# Perl API installed, but this could be all ran from the
# ESX host. If you're using ESXi you would need to run it
# from a remote machine.
#
# $CS variable is the credstore path exported in my profile
# eg, /home/eblack/.vmware/credstore/vicredentials.xml
# 
# Since this script only needs to target a single host to pull datastore
# information I just have that hard coded. The rest of the code could
# probably be cleaned up to pass arguments as expanded variables...

declare -a esxhost
esxhost=( $( esxcfg-scsidevs --server YourEsxHost --credstore $CS -m | awk '{if($NF !~ /phxesx/)print "/vmfs/volumes/"$NF}') )

apush(){
  local grab=$(vmkfstools --server YourEsxHost --credstore $CS /vmfs/volumes/esx_templates --queryfs -P)
  eval "$1=( $grab )"
}

# The updated Python tool for vmkfstools automatically does unit conversion
# to 'human readable'. I need to capture the output from this command, and
# filter it through awk, or something to do the same thing.
for i in ${esxhost[*]}; do
  vmkfstools --server YourEsxHost --credstore $CS $i --queryfs -P
done
