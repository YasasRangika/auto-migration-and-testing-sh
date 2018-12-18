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

##Run jmeter and create roles and users on current version of APIM

./scripts/roles_and_users_creation.sh

##Run jmeter and populate data on current version of APIM

./scripts/jmeter_data_population.sh

##Copy the MySQL JDBC driver JAR

if cp data/mysql-connector-java-8.0.13.jar $to_new_path/wso2am-$new_version/repository/components/lib
then
	echo  Successfully copied the MySQL JDBC driver JAR.
else
	echo Copying the MySQL JDBC driver JAR is failed.
fi

##3.Master-datasources.xml file and provide the datasource configurations - 3

./scripts/configuring_master_datasource.sh $to_new_path $new_version

##Configuring the /repository/conf/registry.xml file - 4

./scripts/configuring_registry_xml.sh $to_new_path $new_version

##Configuring the /repository/conf/user-mgt.xml file

./scripts/configuring_user_mgt_xml.sh $to_new_path $new_version

##move all synapse configs

./scripts/move_synapse.sh $to_old_path $old_version $to_new_path $new_version

##Copy tenants to new version - 6

./scripts/copy_tenants.sh $to_old_path $old_version $to_new_path $new_version

##Stop all running WSO2 API Manager server instances - 7

./scripts/stop_running_APIM.sh

##Run the gateway artifact migration script - 9

./scripts/run_gateway_artifacts_config_script.sh $old_version $new_version $to_new_path

##Re-indexing the artifacts in the registry.xml - 10

./scripts/reindex_artifacts_registry_xml.sh $to_new_path $new_version

if [ -e ../solr ] 
then
  rm -R ../solr
fi

##Upgrade the API Manager database from version

./scripts/upgrade_databases.sh $old_version $new_version
if [ $? -eq 0 ]
then
	echo Upgraded the API Manager database from version-$old_version to version-$new_version
fi


##**********************From this some parts are not in standard coding format, some are like hard coded....change them
##Upgrade the Identity component in WSO2 API Manager
./scripts/upgrade_identity_components.sh $old_version $new_version $to_new_path $to_old_path

##Run the reg-index.sql script against the REG_DB database
./scripts/reg_index_sql.sh

##Add the tenantloader-1.0.jar
if cp data/rush_re-indexing_2.5.0/tenantloader-1.0.jar $to_new_path/wso2am-$new_version/repository/components/dropins
then
	echo  Successfully copied the tenantloader JAR.
else
	echo Failed to copy the tenantloader JAR.
fi

##Re-indexing the artifacts in the registry
echo "*****************************Re-indexing the artifacts in the registry*********************************"
sed -i.bak 's/\/_system\/local\/repository\/components\/org.wso2.carbon.registry\/indexing\/lastaccesstime/\/_system\/local\/repository\/components\/org.wso2.carbon.registry\/indexing\/lastaccesstime_1/' $to_new_path/wso2am-$new_version/repository/conf/registry.xml
if [ $? -eq 0 ]
then
	echo "Re-indexing the artifacts in the registry.xml is successful."
else
	echo "Configuration failed, Please manually rename the <lastAccessTimeLocation> element in the <API-M_2.x.0_HOME>/repository/conf/registry.xml file."
fi

if [ -e ../solr ] 
then
  rm -R ../solr
fi

gnome-terminal -e "sh $to_new_path/wso2am-$new_version/bin/wso2server.sh"

while ! echo exit | nc localhost 9443
do 
	sleep 10
done

echo waiting till user manually stop the server!!!

while lsof -Pi :9443 -sTCP:LISTEN -t >/dev/null
do 
	sleep 10
done

rm -rf $to_new_path/wso2am-$new_version/repository/components/dropins/tenantloader-1.0.jar
if [ $? -eq 0 ]
then
	echo Successfully removed tenantloader-1.0.jar from it\'s locations.
else
	echo Failed to remove tenantloader-1.0.jar from it\'s locations.
fi

#remove the WSO2 API-M client migration ZIP
if [ -e wso2-api-migration-client.zip ]
then
	rm -rf $to_new_path/wso2am-$new_version/repository/components/dropins/wso2-api-migration-client.zip
	if [ $? -eq 0 ]
	then
		echo Successfully removed wso2-api-migration-client.zip from it\'s locations.
	else
		echo Failed to remove wso2-api-migration-client.zip from it\'s locations.
	fi
fi

gnome-terminal -e "sh $to_new_path/wso2am-$new_version/bin/wso2server.sh"

while ! echo exit | nc localhost 9443
do 
	sleep 10
done

##Run jmeter and test APIs on new version of APIM

./scripts/test_previous_version_APIs.sh

##Run jmeter script to create new API and test it on new version of APIM

./scripts/create_and_test_APIs_in_new_version.sh
















