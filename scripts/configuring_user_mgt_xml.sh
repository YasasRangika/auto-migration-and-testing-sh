#!/bin/bash

case "$end_version" in

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
		echo Error while selecting wso2am-$end_version version of API Manager
	;;
esac

echo "*****************************Move synapse configurations(created) -> /synapse-configs/default*********************************"

