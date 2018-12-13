#!/bin/bash

case "$2" in
	"2.1.0")
		echo "Still not developed this part of code :)"
	;;
	"2.2.0")
		case "$1" in
			"2.0.0")
				echo "Still not developed this part of code :)"
			;;
			"2.1.0")
				echo "Still not developed this part of code :)"
			;;
		esac
	;;
	"2.5.0")
		case "$1" in
			"2.0.0")
				echo "Still not developed this part of code :)"
			;;
			"2.1.0")
				cp -R data/Identity_component_upgrade/wso2is-5.6.0-migration/migration-resources $3/wso2am-$2
				#Open the migration-config.yaml file in the migration-resources directory in wso2is-5.6.0-migration and edit the currentVersion element to 5.3.0 part is done by hard coding. Please make it yaml file editor 'sed'
				if cp data/Identity_component_upgrade/wso2is-5.6.0-migration/org.wso2.carbon.is.migration-5.6.0.jar $3/wso2am-$2/repository/components/dropins
				then
					echo  Successfully copied the wso2.carbon.is.migration JAR.
				else
					echo Failed to copy the wso2.carbon.is.migration JAR.
				fi

				if cp -R $4/wso2am-$1/repository/resources/security $3/wso2am-$2/repository/resources/security
#if cp -TRv $4/wso2am-$1/repository/resources/security $3/wso2am-$2/repository/resources/security -> earlier one
				then
					echo  Successfully Copied and replaced the keystores used in the previous version.
				else
					echo Failed to Copy and replace the keystores used in the previous version.
				fi
		
				gnome-terminal -e "sh $3/wso2am-$2/bin/wso2server.sh -Dmigrate -Dcomponent=identity"

				while ! echo exit | nc localhost 9443
				do 
					sleep 10
				done

				echo waiting till user manually stop the server!!!

				while lsof -Pi :9443 -sTCP:LISTEN -t >/dev/null
				do 
					sleep 10
				done

				rm -rf $3/wso2am-$2/migration-resources
				if [ $? -eq 0 ]
				then
					echo Successfully removed migration-resources directory from it\'s locations.
				else
					echo Failed to remove migration-resources directory from their locations.
				fi

				rm -rf $3/wso2am-$2/repository/components/dropins/org.wso2.carbon.is.migration-5.6.0.jar
				if [ $? -eq 0 ]
				then
					echo Successfully removed org.wso2.carbon.is.migration-5.6.0.jar from it\'s locations.
				else
					echo Failed to remove org.wso2.carbon.is.migration-5.6.0.jar from it\'s locations.
				fi
				
				if cp data/Access_control_migration_client/org.wso2.carbon.apimgt.access.control.migration.client-1.0-SNAPSHOT.jar $3/wso2am-$2/repository/components/dropins
				then
					echo  Successfully copied the apimgt.access.control.migration.client JAR.
				else
					echo Failed to copy the apimgt.access.control.migration.client JAR.
				fi

				gnome-terminal -e "sh $3/wso2am-$2/bin/wso2server.sh -DmigrateAccessControl=true"

				while ! echo exit | nc localhost 9443
				do 
					sleep 10
				done

				echo waiting till user manually stop the server!!!

				while lsof -Pi :9443 -sTCP:LISTEN -t >/dev/null
				do 
					sleep 10
				done

				
			;;
			"2.2.0")
				echo "Still not developed this part of code :)"
			;;
		esac
	;;
	"2.6.0")
		case "$1" in
			"2.0.0")
				echo "Still not developed this part of code :)"
			;;
			"2.1.0")
				echo "Still not developed this part of code :)"
			;;
			"2.2.0")
				echo "Still not developed this part of code :)"
			;;
			"2.5.0")
				echo "Still not developed this part of code :)"
			;;
		esac
	;;
	*)
		echo "Upgrading failed in Identity components!"
	;;
esac
