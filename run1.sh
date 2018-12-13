#!/bin/bash

source properties.conf
##$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$CHANGE THE DATA BASE NAMES IN MASTER DATA SOURCE XML FILE$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*********************************
##If both APIMs are in same folder
if [[ $to_old_path -ef $to_new_path ]] 
then
	#Unzip APIMs
	unzip -qq $to_new_path/\*.zip -d $to_new_path

	#prepare variables
	i=1
	[[ $(ls -A $to_new_path) ]] && for dirs in $to_new_path/*
	do
		[[ $dirs =~ .zip ]] && continue
		re="wso2am-([^/]+)"
		if [[ $(basename $dirs) =~ $re ]]
		then
			eval "version$i=${BASH_REMATCH[1]}"
			i=$((i+1))
		fi
	done

	if [ $version1 \> $version2 ]
	then
		new_version=$version1
		old_version=$version2
	else
		new_version=$version2
		old_version=$version1
	fi
fi

##Copy the MySQL JDBC driver JAR

if cp data/mysql-connector-java-8.0.13.jar $to_old_path/wso2am-$old_version/repository/components/lib
then
	echo  Successfully copied the MySQL JDBC driver JAR.
else
	echo Copying the MySQL JDBC driver JAR is failed.
fi

##Create databases and tables in mysql(if it is mysql)

./scripts/mysql_connection_old_apim.sh $to_old_path $old_version

##Cofigure old APIM's master-datasources.xml file and provide the datasource configurations

./scripts/configuring_master_datasource.sh $to_old_path $old_version

##Configure old APIM's the /repository/conf/registry.xml file

./scripts/configuring_registry_xml.sh $to_old_path $old_version

##Configure old APIM's the /repository/conf/user-mgt.xml file

./scripts/configuring_user_mgt_xml.sh $to_old_path $old_version

##Run the APIM
 
gnome-terminal -e "sh $to_old_path/wso2am-$old_version/bin/wso2server.sh"

while ! echo exit | nc localhost 9443
do 
	sleep 10
done

