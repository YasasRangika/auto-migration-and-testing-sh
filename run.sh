#!/bin/bash

#Run jmeter and do all testings to current version of APIM
cd testing/bin #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DO CHANGES FOR THIS USING pushd AND popd~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sh jmeter.sh -n -t Scenario_001_APIM.jmx -l log.jtl

<<COMMENT
***************uncomment if needed*****************
#Show log
cat log.jtl
***************************************************
COMMENT

echo "****************************configure master-datasources**********************************"

#3.Master-datasources.xml file and provide the datasource configurations
echo Trying to configure master-datasources.xml
if cp -R ../../data/master-datasources.xml ../../../repository/conf/datasources
then
	echo  Successfully  configured
else
	echo Configuration failed
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
echo ***************************Configuring the /repository/conf/registry.xml file***********************************
case "$2" in
	"210")
		echo Trying to configure registry.xml
		if cp -R ../../data/API-M_2.1.0/registry.xml ../../../repository/conf
		then
			echo  Successfully  configured registry.xml
		else
			echo Configuration failed, Please manually configure the /repository/conf/registry.xml file as previous version
		fi
	;;
	"220")
		echo Trying to configure registry.xml
		if cp -R ../../data/API-M_2.2.0/registry.xml ../../../repository/conf/registry.xml
		then
			echo  Successfully  configured registry.xml
		else
			echo Configuration failed, Please manually configure the /repository/conf/registry.xml file as previous version
		fi
	;;
	"250" | "260")
		echo Trying to configure registry.xml
		if cp -R ../../data/API-M_2.5.0_2.6.0/registry.xml ../../../repository/conf/registry.xml
		then
			echo  Successfully  configured registry.xml
		else
			echo Configuration failed, Please manually configure the /repository/conf/registry.xml file as previous version
		fi
	;;
	*)
		echo Error while selecting wso2am-$1 version of API Manager
	;;
esac

echo "*****************************Configuring the /repository/conf/user-mgt.xml file*********************************"

#Configuring the /repository/conf/user-mgt.xml file
case "$2" in

	"210" | "220" | "250" | "260")
		echo Trying to configure user-mgt.xml
		if cp -R ../../data/user-mgt.xml ../../../repository/conf/user-mgt.xml
		then
			echo  Successfully  configured
		else
			echo Configuration failed, Please manually configure the /repository/conf/user-mgt.xml file as previous version
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
		echo Error while selecting wso2am-$2 version of API Manager
	;;
esac

echo "*****************************Move synapse configurations(created) -> /synapse-configs/default*********************************"

<<COMMENT
#Move synapse configurations(created) -> /synapse-configs/default
read -p "Enter your current API Manger path for <API-M_2.1.0_MANAGER_HOME> : " path
COMMENT

#check if path is not empty
if [ -z "$3" ]
then
  echo Path is empty!
  exit
fi
#check if path exist
if [ ! -e "$3" ] 
then
  echo Path does not exists
fi

#Copy all created /synapse-configs/default/api configs	
rsync -aP --exclude=_RevokeAPI_.xml --exclude=_AuthorizeAPI_.xml --exclude=_TokenAPI_.xml --exclude=_UserInfoAPI_.xml  $3/repository/deployment/server/synapse-configs/default/api/* ../../../repository/deployment/server/synapse-configs/default/api

#Copy all created /synapse-configs/default/sequences configs
rsync -aP --exclude=_auth_failure_handler_.xml --exclude=_build_.xml --exclude=_cors_request_handler_.xml --exclude=fault.xml --exclude=main.xml --exclude=_production_key_error_.xml --exclude=_resource_mismatch_handler_.xml --exclude=_sandbox_key_error_.xml --exclude=_throttle_out_handler_.xml --exclude=_token_fault_.xml $3/repository/deployment/server/synapse-configs/default/sequences/* ../../../repository/deployment/server/synapse-configs/default/sequences

#Copy all created /synapse-configs/default/proxy-services configs
rsync -aP --exclude=WorkflowCallbackService.xml $3/repository/deployment/server/synapse-configs/default/proxy-services/* ../../../repository/deployment/server/synapse-configs/default/proxy-services

#Copy all created /synapse-configs/default configs
rsync -aP --exclude=api --exclude=proxy-services --exclude=sequences $3/repository/deployment/server/synapse-configs/default/* ../../../repository/deployment/server/synapse-configs/default

echo "*****************************Move all tenant synapse configurations -> /repository/tenants*********************************"

#Copy tenants to new version
#rsync -aP $2/repository/tenants/* ../../../repository/tenants
cp -R $3/repository/tenants/* ../../../repository/tenants
echo Successfully moved tenants files to new version
cd ../..   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DO CHANGES FOR THIS USING pushd AND popd~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

echo Stop all running WSO2 API Manager server instances...
if fuser -k 9443/tcp
then
	echo Stopped running server
else
	echo Error occured while stopping the server
fi

#Run the gateway artifact migration script
echo "*****************************Running the gateway artifact migration script*********************************"

case "$2" in
	"210")
		if [ "$1" -eq 200 ]
		then
			[[ $(ls -A ../repository/tenants) ]] && for dirs in ../repository/tenants/*
			do
				echo "Trying to run apim$1_to_apim$2_gateway_artifact_migrator.sh in tenant-id : $(basename $dirs)"
				/bin/bash data/migration_scripts/apim200_to_apim210_gateway_artifact_migrator.sh $dirs/synapse-configs/default
				if [ $? -eq 0 ]
				then
					echo  Gateway artifacts configuration successful.
				else
					echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/57743137/apim200_to_apim210_gateway_artifact_migrator.sh?version=1&modificationDate=1487589883000&api=v2"
				fi
			done
		else
			echo Old version entered is not valid.
		fi
	;;
	"220")
		echo Trying to configure registry.xml
		if [ "$1" -eq 200 ]
		then
			[[ $(ls -A ../repository/tenants) ]] && for dirs in ../repository/tenants/*
			do
				echo "Trying to run apim$1_to_apim$2_gateway_artifact_migrator.sh in tenant-id : $(basename $dirs)"
				/bin/bash data/migration_scripts/apim200_to_apim220_gateway_artifact_migrator.sh $dirs/synapse-configs/default
				if [ $? -eq 0 ]
				then
					echo  Gateway artifacts configuration successful.
				else
					echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/87701828/apim200_to_apim220_gateway_artifact_migrator.sh?version=2&modificationDate=1521613529000&api=v2"
				fi
			done
		elif [ "$1" -eq 210 ]
		then
			[[ $(ls -A ../repository/tenants) ]] && for dirs in ../repository/tenants/*
			do
				echo "Trying to run apim$1_to_apim$2_gateway_artifact_migrator.sh in tenant-id : $(basename $dirs)"
				/bin/bash data/migration_scripts/apim210_to_apim220_gateway_artifact_migrator.sh $dirs/synapse-configs/default
				if [ $? -eq 0 ]
				then
					echo  Gateway artifacts configuration successful.
				else
					echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/87701828/apim210_to_apim220_gateway_artifact_migrator.sh?version=1&modificationDate=1521603692000&api=v2"
				fi
			done
		else
			echo Old version entered is not valid.
		fi
	;;
	"250")
		echo Trying to configure registry.xml
		if [ "$1" -eq 200 ]
		then
			echo  Successfully  configured registry.xml
		elif [ "$1" -eq 210 ]
		then
			echo  Successfully  configured registry.xml
		elif [ "$1" -eq 220 ]
		then
			echo  Successfully  configured registry.xml
		else
			echo Configuration failed, Please manually configure the /repository/conf/registry.xml file as previous version
		fi
	;;
	"260")
		echo Trying to configure registry.xml
		if [ "$1" -eq 200 ]
		then
			echo  Successfully  configured registry.xml
		elif [ "$1" -eq 210 ]
		then
			echo  Successfully  configured registry.xml
		elif [ "$1" -eq 220 ]
		then
			echo  Successfully  configured registry.xml
		elif [ "$1" -eq 250 ]
		then
			echo  JUST A SUCCESS MSG!!!
		else
			echo Configuration failed, Please manually configure the /repository/conf/registry.xml file as previous version
		fi
	;;
	*)
		echo "Error while selecting wso2am-$1 version of API Manager"
	;;
esac







