#!/bin/bash

echo "*****************************Running the gateway artifact migration script*********************************"

case "$end_version" in
	"210")
		if [ "$old_version" -eq 200 ]
		then
			echo Run migration sript from apim$old_version to apim$end_version...
			/bin/bash data/migration_scripts/apim200_to_apim210_gateway_artifact_migrator.sh ../repository/deployment/server/synapse-configs/default
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful in super tenant."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/57743137/apim200_to_apim210_gateway_artifact_migrator.sh?version=1&modificationDate=1487589883000&api=v2"
			fi
			[[ $(ls -A ../repository/tenants) ]] && for dirs in ../repository/tenants/*
			do
				echo "Trying to run apim$old_version_to_apim$end_version_gateway_artifact_migrator.sh in tenant-id : $(basename $dirs)"
				/bin/bash data/migration_scripts/apim200_to_apim210_gateway_artifact_migrator.sh $dirs/synapse-configs/default
				if [ $? -eq 0 ]
				then
					echo "Gateway artifacts configuration successful for tenants."
				else
					echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/57743137/apim200_to_apim210_gateway_artifact_migrator.sh?version=1&modificationDate=1487589883000&api=v2"
				fi
			done
		else
			echo Old version entered is not valid.
		fi
	;;



	"220")
		if [ "$old_version" -eq 200 ]
		then
			echo Run migration sript from apim$old_version to apim$end_version...
			/bin/bash data/migration_scripts/apim200_to_apim220_gateway_artifact_migrator.sh ../repository/deployment/server/synapse-configs/default
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful in super tenant."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/87701828/apim200_to_apim220_gateway_artifact_migrator.sh?version=2&modificationDate=1521613529000&api=v2"
			fi

			[[ $(ls -A ../repository/tenants) ]] && for dirs in ../repository/tenants/*
			do
				echo "Trying to run apim$old_version_to_apim$end_version_gateway_artifact_migrator.sh in tenant-id : $(basename $dirs)"
				/bin/bash data/migration_scripts/apim200_to_apim220_gateway_artifact_migrator.sh $dirs/synapse-configs/default
				if [ $? -eq 0 ]
				then
					echo "Gateway artifacts configuration successful for tenants."
				else
					echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/87701828/apim200_to_apim220_gateway_artifact_migrator.sh?version=2&modificationDate=1521613529000&api=v2"
				fi
			done
		elif [ "$old_version" -eq 210 ]
		then
			echo Run migration sript from apim$old_version to apim$end_version...
			/bin/bash data/migration_scripts/apim210_to_apim220_gateway_artifact_migrator.sh ../repository/deployment/server/synapse-configs/default
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful in super tenant."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/87701828/apim210_to_apim220_gateway_artifact_migrator.sh?version=1&modificationDate=1521603692000&api=v2"
			fi

			[[ $(ls -A ../repository/tenants) ]] && for dirs in ../repository/tenants/*
			do
				echo "Trying to run apim$old_version_to_apim$end_version_gateway_artifact_migrator.sh in tenant-id : $(basename $dirs)"
				/bin/bash data/migration_scripts/apim210_to_apim220_gateway_artifact_migrator.sh $dirs/synapse-configs/default
				if [ $? -eq 0 ]
				then
					echo "Gateway artifacts configuration successful for tenants."
				else
					echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/87701828/apim210_to_apim220_gateway_artifact_migrator.sh?version=1&modificationDate=1521603692000&api=v2"
				fi
			done
		else
			echo Configuration failed, Old version entered is not valid!
		fi
	;;


	"250")
		echo Trying to configure registry.xml
		if [ "$old_version" -eq 200 ]
		then
			echo Run migration sript from apim$old_version to apim$end_version...
			/bin/bash data/migration_scripts/apim200_to_apim250_gateway_artifact_migrator.sh ../repository/deployment/server/synapse-configs/default
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful in super tenant."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/92520041/apim200_to_apim250_gateway_artifact_migrator.sh?version=2&modificationDate=1531390783000&api=v2"
			fi

			/bin/bash data/migration_scripts/apim200_to_apim250_gateway_artifact_migrator.sh ../repository/tenants
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful for tenants."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/92520041/apim200_to_apim250_gateway_artifact_migrator.sh?version=2&modificationDate=1531390783000&api=v2"
			fi

		elif [ "$old_version" -eq 210 ]
		then
			echo Run migration sript from apim$old_version to apim$end_version...
			/bin/bash data/migration_scripts/apim210_to_apim250_gateway_artifact_migrator.sh ../repository/deployment/server/synapse-configs/default
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful in super tenant."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/92520041/apim210_to_apim250_gateway_artifact_migrator.sh?version=2&modificationDate=1531390716000&api=v2"
			fi

			/bin/bash data/migration_scripts/apim210_to_apim250_gateway_artifact_migrator.sh ../repository/tenants
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful for tenants."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/92520041/apim210_to_apim250_gateway_artifact_migrator.sh?version=2&modificationDate=1531390716000&api=v2"
			fi
		elif [ "$old_version" -eq 220 ]
		then
			echo Run migration sript from apim$old_version to apim$end_version...
			/bin/bash data/migration_scripts/apim220_to_apim250_gateway_artifact_migrator.sh ../repository/deployment/server/synapse-configs/default
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful in super tenant."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/92520041/apim220_to_apim250_gateway_artifact_migrator.sh?version=3&modificationDate=1531390424000&api=v2"
			fi

			/bin/bash data/migration_scripts/apim220_to_apim250_gateway_artifact_migrator.sh ../repository/tenants
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful for tenants."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/92520041/apim220_to_apim250_gateway_artifact_migrator.sh?version=3&modificationDate=1531390424000&api=v2"
			fi
		else
			echo Configuration failed, Old version entered is not valid!
		fi
	;;



	"260")
		echo Trying to configure registry.xml
		if [ "$old_version" -eq 200 ]
		then
			echo Run migration sript from apim$old_version to apim$end_version...
			/bin/bash data/migration_scripts/apim200_to_apim260_gateway_artifact_migrator.sh ../repository/deployment/server/synapse-configs/default
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful in super tenant."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/97568830/apim200_to_apim260_gateway_artifact_migrator.sh?version=2&modificationDate=1539197141000&api=v2"
			fi

			/bin/bash data/migration_scripts/apim200_to_apim260_gateway_artifact_migrator.sh ../repository/tenants
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful for tenants."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/97568830/apim200_to_apim260_gateway_artifact_migrator.sh?version=2&modificationDate=1539197141000&api=v2"
			fi
		elif [ "$old_version" -eq 210 ]
		then
			echo Run migration sript from apim$old_version to apim$end_version...
			/bin/bash data/migration_scripts/apim210_to_apim260_gateway_artifact_migrator.sh ../repository/deployment/server/synapse-configs/default
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful in super tenant."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/97568830/apim210_to_apim260_gateway_artifact_migrator.sh?version=2&modificationDate=1539060996000&api=v2"
			fi

			/bin/bash data/migration_scripts/apim210_to_apim260_gateway_artifact_migrator.sh ../repository/tenants
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful for tenants."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/97568830/apim210_to_apim260_gateway_artifact_migrator.sh?version=2&modificationDate=1539060996000&api=v2"
			fi
		elif [ "$old_version" -eq 220 ]
		then
			echo Run migration sript from apim$old_version to apim$end_version...
			/bin/bash data/migration_scripts/apim220_to_apim260_gateway_artifact_migrator.sh ../repository/deployment/server/synapse-configs/default
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful in super tenant."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/97568830/apim220_to_apim260_gateway_artifact_migrator.sh?version=1&modificationDate=1538924050000&api=v2"
			fi

			/bin/bash data/migration_scripts/apim220_to_apim260_gateway_artifact_migrator.sh ../repository/tenants
			if [ $? -eq 0 ]
			then
				echo "Gateway artifacts configuration successful for tenants."
			else
				echo "Configuration failed, Please manually configure the gateway artifacts downloading from https://docs.wso2.com/download/attachments/97568830/apim220_to_apim260_gateway_artifact_migrator.sh?version=1&modificationDate=1538924050000&api=v2"
			fi
		elif [ "$old_version" -eq 250 ]
		then
			echo No need of gateway artifacts configuration. Complete.
		else
			echo Configuration failed, Old version entered is not valid!
		fi
	;;
	*)
		echo "Error while selecting wso2am-$end_version version of API Manager"
	;;
esac
