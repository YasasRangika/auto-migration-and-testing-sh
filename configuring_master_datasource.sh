#!/bin/bash

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
#Take the paths to configure APIM versions as run time paramters and then when calling to this script from run.sh give the values as well
