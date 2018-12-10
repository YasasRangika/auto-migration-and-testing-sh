#!/bin/bash

#rsync -aP $end_version/repository/tenants/* ../../../repository/tenants
cp -R $1/wso2am-$2/repository/tenants/* $3/wso2am-$4/repository/tenants
echo Successfully moved tenants files to new version
cd ../..   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DO CHANGES FOR THIS USING pushd AND popd~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

