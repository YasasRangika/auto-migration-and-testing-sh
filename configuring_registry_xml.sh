#!/bin/bash

echo ***************************Configuring the /repository/conf/registry.xml file***********************************
case "$end_version" in
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
		echo Error while selecting wso2am-$old_version version of API Manager
	;;
esac

echo "*****************************Configuring the /repository/conf/user-mgt.xml file*********************************"

