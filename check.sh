#!/bin/bash

<<comment
[[ $(ls -A /home/yasas/Documents/WSO2/wso2am-2.5.0/repository/tenants) ]] && for output in /home/yasas/Documents/WSO2/wso2am-2.5.0/repository/tenants/*
do
    echo $output
done
comment

echo yasas

