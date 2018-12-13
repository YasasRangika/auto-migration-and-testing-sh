#!/bin/bash

if cp -R /home/yasas/Music/Test/* /home/yasas/Videos/Test
then
	echo  Successfully Copied and replaced the keystores used in the previous version.
else
	echo Failed to Copy and replace the keystores used in the previous version.
fi
