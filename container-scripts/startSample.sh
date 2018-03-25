#!/bin/sh
#
# Copyright (c) 2015 Oracle and/or its affiliates. All rights reserved.
#

# Define default command to create medrec domain 
USERNAME=${USERNAME:-weblogic}
PASSWORD=${PASSWORD:-welcome1}

DB_UserName=sys
DB_Password=Oradoc_db1
DB_HostName=orcldb
DB_Port=1521
DB_SID=ORCLCDB
SQLPLUS=/u01/oracle/sqlcl/bin/sql


db_statuscheck() {
   COUNT=0
   while :
   do
	echo "`date` :Checking DB connectivity...";
	echo "`date` :Trying to connect "${DB_UserName}"/"${DB_Password}"@"${DB_SID}" ..."

	echo "exit" | ${SQLPLUS} -L ${DB_UserName}"/"${DB_Password}@${DB_HostName}:${DB_Port}:${DB_SID} as sysdba | grep Connected > /dev/null
	if [ $? -eq 0 ]
	then
		DB_STATUS="UP"
		export DB_STATUS
		echo "`date` :Status: ${DB_STATUS}. Able to Connect..."
		echo "`date` :Status: ${DB_STATUS}. Populate data..."
		echo "@/u01/oracle/demo_oracle.ddl" | ${SQLPLUS} -L ${DB_UserName}"/"${DB_Password}@${DB_HostName}:${DB_Port}:${DB_SID} as sysdba
		break
	else
		DB_STATUS="DOWN"
		export DB_STATUS
		echo "`date` :Status: DOWN . Not able to Connect."
		echo "`date` :Not able to connect to database with Username: "${DB_UserName}" Password: "${DB_Password}" DB HostName: "${DB_HostName}" DB Port: "${DB_Port}" SID: "${DB_SID}"."
		sleep 30
		COUNT=$((COUNT + 1))
                if [ $COUNT -gt 30 ]
                then
			echo "`date` :Status: DOWN . Please check if DB is healthy, unable to connect to DB for long time."
			exit 1
		fi
	fi
   done
}

db_statuscheck


${ORACLE_HOME}/wlserver/samples/server/run_samples.sh "${USERNAME}" "${PASSWORD}"
wlst.sh -loadProperties /u01/oracle/oradatasource.properties /u01/oracle/medrec-ds-deploy.py 

${ORACLE_HOME}/wlserver/samples/domains/medrec/startWebLogic.sh

