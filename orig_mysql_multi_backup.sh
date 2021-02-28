#!/bin/bash
#
# (c) 2015 - Steffen Gutermann
#
# Distributed under the Apache License 2.0
# http://www.apache.org/licenses/
#
# A permissive license that also provides an express grant of patent rights from contributors to users. So if you got something
# that needs to flow into the code, let me know.
#
# Required		 	Permitted	 	Forbidden
#
# License and copyright notice	Commercial Use		Hold Liable
# State Changes			Distribution		Use Trademark
#				Modification
#				Patent Grant
#				Private Use
#				Sublicensing
#
# version 0.1 Alpha - June 2015 - this is the Start
# version 0.2 Alpha - June 2015 - basic structure and workings
# version 0.3 Alpha - July 2015 - included installer script
#
# General purpose is to keep it simple. Backup all MySQLs Databases from various Servers, but keep it flexible to allow
# different access setup scenarios for each one.
#
# TO DO
# 1. get the Logs going
# 2. get a failmail going
# 3. optional successmail
# 4. get a remote sync included
#
#########
# Debug #
#########
#
# If you need to debug something, this line helps
# trap 'printf "$LINENO :-> " ; read line ; eval $line' DEBUG
#
################
# GENERAL CONF #
################
#
# Presuming you ran the install script, folder structure should be in place
# and existing commands should be checked so nothing to be done here
#
##############
# OTHER CONF #
##############
#
SCRIPTNAME=mysql_multi_backup.sh
HOST=`hostname | awk -F. '{print $1}'`
CURRENT_DATE="$(date +%Y_%m_%d)";
CURRENT_TIME="$(date +%H_%M)";
#
#
MYSQL=`which mysql`
MYSQLDUMP=`which mysqldump`
#
#############
# Structure #
#############
#
# BASEDIR
# 	- bin
#       - conf
#       - mysql-dumps
#       	- remotehost_current_date
#               	- mysqlhost_db_current_time
#       - log
#
# - if you did not use the install script you MUST enter the location of the BASEDIR
# - in oder to run you need to place at least one "bla.conf" in the conf folder
#
#
BASEDIR=REPLACEMEPATH
BINDIR=${BASEDIR}/bin
CONFDIR=${BASEDIR}/conf
RESULTDIR=${BASEDIR}/mysql-dumps
LOGDIR=${BASEDIR}/log
#
###########################
# Data TO BE IN CONF FILE #
###########################
#
#MYSQL_USER="user"
#MYSQL_PASSWORD="pw"
#MYSQL_HOST="server.test.com"
#MYSQLDUMP_OPTS="--events"
#EXTHIS="(information_schema|performance_schema)"
#MYSQL_PORT="3306"
#
###########################
# Sync someplace          #
###########################
#
#
# NOT IMPLEMENTED YET
#
#
#SYNCSERVER="backup.fqdn.de"
#SYNCUSER="horscht"
#SYNCSSHPORT="22"
#SYNCDIR="/externalbackups/mysql-dumps-from-horscht/"
#
##########################
# DO THE BACKUPS         #
##########################
#
#
#
for filename in $CONFDIR/*.conf; do
    for ((i=0; i<=3; i++)); do
        # LIST DBs TO GO FOR BU
        source $filename
        DATABASES=`$MYSQL -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT -Bse 'show databases' | grep -Ev $EXTHIS`
        for DB in $DATABASES; do
            DUMPDIR=${RESULTDIR}/${MYSQL_HOST}_${CURRENT_DATE}
            if [ ! -d ${DUMPDIR} ]
                then
                mkdir -p ${DUMPDIR}
            fi
            $MYSQLDUMP $MYSQLDUMP_OPTS -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT --databases $DB | gzip > ${DUMPDIR}/${MYSQL_HOST}_${DB}_${CURRENT_TIME}.gz
        done
    done
done
#
# RSYNC TO OTHER SERVER
#
# rsync -p ${SYNCSSHPORT} -a ${RESULTDIR}/* ${SYNCUSER}@${SYNCSERVER}:${SYNCDIR}
#
# ERROR LOGGING
#
# FAIL MAIL or SUCCESS MAIL
#
#
#

