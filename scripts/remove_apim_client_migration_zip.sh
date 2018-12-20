#!/bin/bash

if [ -e wso2-api-migration-client.zip ]
then
	rm -rf $1/wso2am-$2/repository/components/dropins/wso2-api-migration-client.zip
	if [ $? -eq 0 ]
	then
		echo Successfully removed wso2-api-migration-client.zip from it\'s locations.
	else
		echo Failed to remove wso2-api-migration-client.zip from it\'s locations.
	fi
fi
