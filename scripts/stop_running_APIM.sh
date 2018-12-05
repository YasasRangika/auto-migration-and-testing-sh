#!/bin/bash

echo Stop all running WSO2 API Manager server instances...
if fuser -k 9443/tcp
then
	echo Stopped running server
else
	echo Error occured while stopping the server
fi
