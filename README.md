Example of Image with WLS Domain
================================

This is an  extension of the [Oracle official Weblogic docker project] (https://github.com/oracle/docker-images/OracleWeblogic).

This Dockerfile extends the Oracle WebLogic image by installing the Supplemental package of WebLogic which includes the MedRec WLS sample and some additional changes to automate build and bring up of Oracle DB and Medrec through docker-compose

clone this repo:
git clone https://github.com/uday-shetty/docker-for-oracle-weblogic

Before continuing, make sure you download the WebLogic Server 12.2.1.2 Supplemental Quick Installer from OTN [fmw_12.2.1.2.0_wls_supplemental_quick_Disk1_1of1.zip](http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-for-dev-1703574.html), and drop the zip file (without extracting it!) into folder 12212-oradb-medrec.

Note: sqlcl is downloaded for convenience. Check Oracle Website for latest versions.
Download (http://www.oracle.com/technetwork/developer-tools/sqlcl/downloads/index.html), and install sqlcl, a new command-line tool for connecting to the Oracle Database.

The Dockerfile uses Weblogic and Database images from Docker Store (https://store.docker.com)

Assumptions: Dockerfile and docker-compose is based on  default Database user/password for this demo.

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

Note: login to Docker Store/Hub before running docker-compose: 'docker login'

To build, run:

        $ docker-compose up -d

        This will build Weblogic and Medrec domain, brings up Oracle Database and Weblogic. It takes ~4 mins for application to be ready. 

        Check logs for Weblogic Container 'docker logs -f <weblogic container-id>'

        Check logs for database 'docker logs -f <database container id>' 

To shut down

        $ docker-compose down

To clean up

        $ docker-compose rm
        $ docker volume rm $(docker volume ls -qf dangling=true)


To bring up Weblogic console

	http://localhost:7011/console   (weblogic/welcome1)

To access the MedRec application, go to:

        http://localhost:7011/medrec
