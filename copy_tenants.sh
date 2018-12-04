#!/bin/bash

#rsync -aP $end_version/repository/tenants/* ../../../repository/tenants
cp -R $to_old_path/repository/tenants/* ../../../repository/tenants
echo Successfully moved tenants files to new version
cd ../..   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DO CHANGES FOR THIS USING pushd AND popd~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

