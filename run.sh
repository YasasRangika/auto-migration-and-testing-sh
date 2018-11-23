#!/bin/bash

#Run jmeter and do all testings to current version of APIM
cd testing/bin
sh jmeter.sh -n -t Scenario_001_APIM.jmx -l log.jtl

<<COMMENT
***************uncomment if needed*****************
#Show log
cat log.jtl
***************************************************
COMMENT

echo "**************************************************************"

#3.Master-datasources.xml file and provide the datasource configurations
echo "Trying to configure master-datasources.xml"
if cp -R ../../data/master-datasources.xml ../../../repository/conf/datasources
then
	echo  "Successfully  configured"
else
	echo "Configuration failed"
fi

<<COMMENT
*********************removed*****************************
read -p "Please enter current version of API Manager(ex:210) : "  current_ver
echo "Your current API Manager version is wso2am-$current_ver."
read -p "Now enter the version you are going to migrate(ex:250) : " migrate_ver
echo "You are going to migrate API Manager version wso2am-$migrate_ver."
*********************************************************
COMMENT

#Configuring the /repository/conf/registry.xml file
echo "**************************************************************"
case "$1" in
	"210")
		echo "Trying to configure registry.xml"
		if cp -R ../../data/API-M_2.1.0/registry.xml ../../../repository/conf
		then
			echo  "Successfully  configured registry.xml"
		else
			echo "Configuration failed, Please manually configure the /repository/conf/registry.xml file as previous version"
		fi
	;;
	"220")
		echo "Trying to configure registry.xml"
		if cp -R ../../data/API-M_2.2.0/registry.xml ../../../repository/conf/registry.xml
		then
			echo  "Successfully  configured registry.xml"
		else
			echo "Configuration failed, Please manually configure the /repository/conf/registry.xml file as previous version"
		fi
	;;
	"250" | "260")
		echo "Trying to configure registry.xml"
		if cp -R ../../data/API-M_2.5.0_2.6.0/registry.xml ../../../repository/conf/registry.xml
		then
			echo  "Successfully  configured registry.xml"
		else
			echo "Configuration failed, Please manually configure the /repository/conf/registry.xml file as previous version"
		fi
	;;
	*)
		echo "Error while selecting wso2am-$1 version of API Manager"
	;;
esac

echo "**************************************************************"

#Configuring the /repository/conf/user-mgt.xml file
case "$1" in

	"210" | "220" | "250" | "260")
		echo "Trying to configure user-mgt.xml"
		if cp -R ../../data/user-mgt.xml ../../../repository/conf/user-mgt.xml
		then
			echo  "Successfully  configured"
		else
			echo "Configuration failed, Please manually configure the /repository/conf/user-mgt.xml file as previous version"
		fi
	;;

	#If a new version with defferent user-mgt.xml file,
	# copy configured user-mgt.xml file to new folder named version in data directory, then edit xxx and uncomment this
	# "xxx")
	#	echo "Trying to configure user-mgt.xml"
	#	if cp -R ../../data/registryXXX.xml ../../../repository/conf/user-mgt.xml
	#	then
	#		echo  "Successfully  configured"
	#	else
	#		echo "Configuration failed, Please manually configure the /repository/conf/user-mgt.xml file as previous version"
	#	fi
	# ;;
	

	*)
		echo "Error while selecting wso2am-$1 version of API Manager"
	;;
esac

echo "**************************************************************"

<<COMMENT
#Move synapse configurations(created) -> /synapse-configs/default
read -p "Enter your current API Manger path for <API-M_2.1.0_MANAGER_HOME> : " path
COMMENT

#check if path is not empty
if [ -z "$2" ]
then
  echo "Path is empty!"
  exit
fi
#check if path exist
if [ ! -e "$2" ] 
then
  echo "Path does not exists"
fi


#rsync -av --exclude=''$2'/repository/deployment/server/synapse-configs/default/api/_AuthorizeAPI_.xml' $2/repository/deployment/server/synapse-configs/default/ ../../../repository/deployment/server/synapse-configs

cd ../..
current_path=$(pwd)
cd ~/../..

shopt -s extglob
#copy all the synapse-configs of except  mentioned files
cp $2/repository/deployment/server/synapse-configs/default/api/!(_*.xml) $current_path/../repository/deployment/server/synapse-configs
cp $2/repository/deployment/server/synapse-configs/default/api/!(_*.xml) $current_path/../repository/deployment/server/synapse-configs
shopt -u extglob
cd $current_path
pwd

