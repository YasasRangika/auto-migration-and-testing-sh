#!/bin/bash

#**************************Rename below db names to regdb, userdb and amdb before hand-over*******************************
db1="regdb1"
db2="userdb1"
db3="amdb1"
#***********************************************************************************************************************

Q1="CREATE DATABASE IF NOT EXISTS $db1;"
Q2="CREATE DATABASE IF NOT EXISTS $db2;"
Q3="CREATE DATABASE IF NOT EXISTS $db3;"

SQL="${Q1}${Q2}${Q3}"
mysql -u root -e "$SQL";

cd ..

echo -ne 'starting...                     (0%)\r'
mysql -u root -D$db1 < 'dbscripts/mysql5.7.sql';
echo -ne '########                       (40%)\r'
mysql -u root -D$db2 < 'dbscripts/mysql5.7.sql';
echo -ne '#####################          (70%)\r'
mysql -u root -D$db3 < 'dbscripts/apimgt/mysql5.7.sql';
echo -ne '##############################(100%)\r'
echo -ne 'completed.                          \r'
