Example of Image with WLS Domain
================================

This is an  extension of the [Oracle official Weblogic docker project] (https://github.com/oracle/docker-images/OracleWeblogic).

This Dockerfile extends the Oracle WebLogic image by installing the Supplemental package of WebLogic which includes the MedRec WLS sample and some additional changes to automate build and bring up of Oracle DB and Medrec through docker-compose

Step 1: 
git clone https://github.com/uday-shetty/docker-for-oracle-weblogic

Step 2: 
Download the WebLogic Server 12.2.1.2 Supplemental Quick Installer from OTN [fmw_12.2.1.2.0_wls_supplemental_quick_Disk1_1of1.zip](http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-for-dev-1703574.html), and drop the zip file (without extracting it!) into current folder

Step 3:
Download command-line tool for connecting to the Oracle Database from OTN [sqlcl-17.4.0.354.2224-no-jre.zip](http://www.oracle.com/technetwork/developer-tools/sqlcl/downloads/index.html), and drop the zip file (without extracting it!) into current folder

The Dockerfile uses Weblogic and Database images from Docker Store (https://store.docker.com)

Assumptions: Dockerfile and docker-compose is based on  default Database user/password for this demo.

Step 4: (optional)
If there are changes to DB username/password, edit the *12212-oradb-medrec/container-scripts/oradatasource.properties*, set the Oracle Thin XA driver, the Database URL, username, password, and DB container name to connect to the Oracle Database container.

```
domainname=medrec
domainhome=/u01/oracle/wlserver/samples/domains/medrec
admin_name=MedRecServer
dsname=MedRecGlobalDataSourceXA
dsdbname=ORCLCDB
dsjndiname=jdbc/MedRecGlobalDataSourceXA
dsdriver=oracle.jdbc.xa.client.OracleXADataSource
dsurl=jdbc:oracle:thin:@orcldb:1521:ORCLCDB
dsusername=sys as sysdba
dspassword=Ora_docdb1
dstestquery=SELECT * FROM DUAL
dsmaxcapacity=1
```

Step 5:  
Login to Docker Store/Hub before running docker-compose: 'docker login'

Step 6:
To build:
	$ ./build.sh

Step 7:
To run:

        $ docker-compose up -d

        This brings up Oracle Database and Weblogic/Medrec. It takes ~5-6 mins for application to be ready as Weblogic will wait for Database to be ready. 
	Note: A label has been added to the node above to identify the Oracle Database node. Proper functioning of the database requires 2-4 cpus, 8-16GB memory, and 12-16GB local storage.

        Check logs for Weblogic Container 'docker logs -f <weblogic container-id>'

        Check logs for database 'docker logs -f <database container id>' 

To shut down

        $ docker-compose down

To clean up

        $ docker-compose rm
        $ docker volume rm $(docker volume ls -qf dangling=true)


To bring up Weblogic console

	http://localhost:7011/console   (weblogic/welcome1)

To access the MedRec application

	http://localhost:7011/medrec

