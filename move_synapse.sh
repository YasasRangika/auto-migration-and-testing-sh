#!/bin/bash

<<COMMENT
#Move synapse configurations(created) -> /synapse-configs/default
read -p "Enter your current API Manger path for <API-M_2.1.0_MANAGER_HOME> : " path
COMMENT

#check if path is not empty
if [ -z "$to_old_path" ]
then
  echo Path is empty!
  exit
fi
#check if path exist
if [ ! -e "$to_old_path" ] 
then
  echo Path does not exists
fi

#Copy all created /synapse-configs/default/api configs - 5
rsync -aP --exclude=_RevokeAPI_.xml --exclude=_AuthorizeAPI_.xml --exclude=_TokenAPI_.xml --exclude=_UserInfoAPI_.xml  $to_old_path/repository/deployment/server/synapse-configs/default/api/* ../../../repository/deployment/server/synapse-configs/default/api

#Copy all created /synapse-configs/default/sequences configs
rsync -aP --exclude=_auth_failure_handler_.xml --exclude=_build_.xml --exclude=_cors_request_handler_.xml --exclude=fault.xml --exclude=main.xml --exclude=_production_key_error_.xml --exclude=_resource_mismatch_handler_.xml --exclude=_sandbox_key_error_.xml --exclude=_throttle_out_handler_.xml --exclude=_token_fault_.xml $to_old_path/repository/deployment/server/synapse-configs/default/sequences/* ../../../repository/deployment/server/synapse-configs/default/sequences

#Copy all created /synapse-configs/default/proxy-services configs
rsync -aP --exclude=WorkflowCallbackService.xml $to_old_path/repository/deployment/server/synapse-configs/default/proxy-services/* ../../../repository/deployment/server/synapse-configs/default/proxy-services

#Copy all created /synapse-configs/default configs
rsync -aP --exclude=api --exclude=proxy-services --exclude=sequences $to_old_path/repository/deployment/server/synapse-configs/default/* ../../../repository/deployment/server/synapse-configs/default

echo "*****************************Moved all tenant synapse configurations -> /repository/tenants*********************************"

