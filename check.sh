#!/bin/bash
source properties.conf

	#Unzip APIMs
	#unzip -o $to_old_path/\*.zip -d $to_old_path | awk 'BEGIN {ORS=" "} {if(NR%100==0)print "."}'
	#unzip -qq $to_old_path/\*.zip -d $to_old_path | awk 'BEGIN {ORS=" "} {print "."}'
	#unzip -qq $to_new_path/\*.zip -d $to_new_path | awk 'BEGIN {ORS=" "} {if(NR%10==0)print "."}'

	


unzip -qq $to_old_path/\*.zip -d $to_old_path &
PID=$!
i=1
sp="/―\|"
echo -n Unzipping API manger old version [processing] : ' '
while [ -d /proc/$PID ]
do
  printf "\b${sp:i++%${#sp}:1}"
done




#echo old version : $old_version
#echo new version : $new_version
