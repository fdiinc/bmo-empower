#!/bin/sh
#This script will create a new xDB federation, a new xDB database within the new federation and add the new federation to the existing federation set.
#xDB needs to be installed and the federation set needs to be created before running this.
#Run script as xdb user.

FEDERATION_SET_DIR=/opt/xDB/data
FEDERATION_SET_FILE=BMO.fs
FEDERATION_DIR=/opt/xDB/data/empower
FEDERATION_NAME=empower
FEDERATION_FILE=/opt/xDB/data/empower/XhiveDatabase.bootstrap
FEDERATION_PASSWORD=BMO-empower
FEDERATION_LICENSE=060xxy96xxy06xxy.6xxy/6xxyD6xxyE6xxyM6x1xyN6HydIA#YTZRSRZYZQTSyaFiNmSj8eshpY
DATABASE_PASSWORD=BMO-empower
DATABASE_NAME=bmoempower

echo "Creating federation directory"
mkdir -p ${FEDERATION_DIR}

echo "Adding ${FEDERATION_NAME} federation to ${FEDERATION_SET_FILE} federation set"
/opt/xDB/bin/xdb federation-set addfd ${FEDERATION_SET_DIR}/${FEDERATION_SET_FILE} --name ${FEDERATION_NAME} --value ${FEDERATION_FILE}

echo "Creating ${FEDERATION_NAME} federation"
/opt/xDB/bin/xdb create-federation --federation ${FEDERATION_FILE} --supasswd ${FEDERATION_PASSWORD} --licensekey ${FEDERATION_LICENSE}

echo "Creating" ${DATABASE_NAME} DB in "${FEDERATION_NAME} federation"
/opt/xDB/bin/xdb create-database -p ${FEDERATION_PASSWORD} --adminpwd ${DATABASE_PASSWORD} ${DATABASE_NAME} --federation ${FEDERATION_FILE}

echo "Running load-application-data"
cd /code/bmo-workspace/DDS/bin/ &&  ./dds-ant.sh load-application-data -Dapp=bmoempower -Dforce=true

echo "Running load-data-sets"
cd /code/bmo-workspace/DDS/bin/ &&  ./dds-ant.sh load-data-sets -Dapp=bmoempower -Dforce=true

echo "Building and deploying war"
cd /code/bmo-workspace/DDS/bin/ && /opt/tomcat/bin/shutdown.sh && ./dds-ant.sh clean build war -Dapp=bmoempower && rm -rf /opt/tomcat/webapps/bmoempower*  && cp /code/bmo-workspace/DDS/build/bmoempower.war /opt/tomcat/webapps/ && /opt/tomcat/bin/startup.sh

echo "Done"
