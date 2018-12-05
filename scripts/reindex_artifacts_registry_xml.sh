#!/bin/bash

if [ "$end_version" -eq 210 ] || [ "$end_version" -eq 220 ]
then
echo "*****************************Re-indexing the artifacts in the registry*********************************"
sed -i.bak 's/\/_system\/local\/repository\/components\/org.wso2.carbon.registry\/indexing\/lastaccesstime/\/_system\/local\/repository\/components\/org.wso2.carbon.registry\/indexing\/lastaccesstime_1/' ../repository/conf/registry.xml
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
fi
