#!/bin/bash
# This prepares for mysql_multi_backup.sh script make sure the orig_mysql_multi_backup.sh
# is sitting right next to this one as it is actually the template.
#
# Version 0.1 Alpha - do not expect anything other than caos to happen.
# Everything that works after that is more than expected.
#
#
#############
# Funktions #
#############

function gogo {
echo -e " \033[0;32m "
echo " "
echo "  _______   ______    __ "
echo " /  _____| /  __  \  |  |"
echo "|  |  __  |  |  |  | |  |"
echo "|  | |_ | |  |  |  | |  |"
echo "|  |__| | |  '--'  | |__|"
echo " \______|  \______/  (__)"
echo " "
echo -e " \033[0m "

}

function donedone {
echo -e " \033[0;32m "
echo " "
echo " _______   ______   .__   __.  _______  __ "
echo "|       \ /  __  \  |  \ |  | |   ____||  |"
echo "|  .--.  |  |  |  | |   \|  | |  |__   |  |"
echo "|  |  |  |  |  |  | |  . '  | |   __|  |  |"
echo "|  '--'  |  '--'  | |  |\   | |  |____ |__|"
echo "|_______/ \______/  |__| \__| |_______|(__)"
echo " "
echo -e " \033[0m "
}

function failfail {
echo -e " \033[0;31m "
echo " "
echo " _______    ___       __   __       __ "
echo "|   ____|  /   \     |  | |  |     |  |"
echo "|  |__    /  ^  \    |  | |  |     |  |"
echo "|   __|  /  /_\  \   |  | |  |     |  |"
echo "|  |    /  _____  \  |  | |  '----.|__|"
echo "|__|   /__/     \__\ |__| |_______|(__)"
echo " "
echo -e " \033[0m "
exit 1
}

function sampleecho {
echo '#sample config file - save as host.conf in the conf folder'
echo 'MYSQL_USER="user"'
echo 'MYSQL_PASSWORD="pw"'
echo 'MYSQL_HOST="server.sample.com"'
echo 'MYSQLDUMP_OPTS="--events"'
echo 'EXTHIS="(information_schema|performance_schema)"'
echo 'MYSQL_PORT="3306"'
}

function makefirstconfig {
echo " "
echo "Makeing Config"
echo " "
read -p "MySQL Host: " -r
MYHOST=${REPLY}
echo 'MYSQL_HOST="'${MYHOST}'"' > ${BACKUPPATH}/conf/${MYHOST}.conf
read -p "MySQL User: " -r
echo 'MYSQL_USER="'${REPLY}'"' >> ${BACKUPPATH}/conf/${MYHOST}.conf
read -p "MySQL User Password: " -r
echo 'MYSQL_PASSWORD="'${REPLY}'"' >> ${BACKUPPATH}/conf/${MYHOST}.conf
read -e -p 'Enter the your MYSQLDUMP_OPS for this host or hit [RETURN] for default: ' -i '--events' DUMP_OPTS
echo 'MYSQLDUMP_OPTS="'${DUMP_OPTS}'"' >> ${BACKUPPATH}/conf/${MYHOST}.conf
read -e -p "Enter tables to be excluded for this host or hit [RETURN] for default: " -i "(information_schema|performance_schema)" EXTHIS
echo 'EXTHIS="'${EXTHIS}'"' >> ${BACKUPPATH}/conf/${MYHOST}.conf
read -e -p "Enter the MySQL Port of the host or hit [RETURN] for default: " -i "3306" MPORT
echo 'MYSQL_PORT="'${MPORT}'"' >> ${BACKUPPATH}/conf/${MYHOST}.conf
}
######################
# Check a few things #
######################
#
gogo;
echo "First let us check for a few commands on the System."
echo " "
command -v date >/dev/null 2>&1 || { echo >&2 "I can not find the date? I am lost in time. Sorry!"; echo " "; failfail; }
command -v awk >/dev/null 2>&1 || { echo >&2 "I would like to have awk but it's not installed. Can you help?"; echo " "; failfail; }
command -v mysql >/dev/null 2>&1 || { echo >&2 "Having MySql goes without saying if you are planning on backing it up, no?"; echo " "; failfail; }
command -v mysqldump >/dev/null 2>&1 || { echo >&2 "Can not find mysqldump, how do you expect to make dumps? Please install."; echo " "; failfail; }
command -v sed >/dev/null 2>&1 || { echo >&2 "Can not find sed, but need it to replace some stuff in the template script for you."; echo " "; failfail; }
echo "All commands seem to be available that I was looking for."
echo " "
#######################
# Where to put it all #
#######################
#
echo "Now you have to decide on a place to put everything. This should be a place that does not exist as of yet."
echo " "
read -e -p "Enter the path or hit [RETURN] for default: " -i "/data/backup" NEWBACKUPPATH
if [ "${NEWBACKUPPATH}" == "" ] ; then
BACKUPPATH="/data/backup"
else
BACKUPPATH=${NEWBACKUPPATH%/}
fi
echo " "
echo "Ok ${BACKUPPATH} is the chosen one."
echo " "
if [ -d ${BACKUPPATH} ] ; then
	echo "${BACKUPPATH} already exists ... exiting ... this is too hot for me."
	echo " "
	failfail
fi
mkdir -p ${BACKUPPATH}/bin ${BACKUPPATH}/conf ${BACKUPPATH}/log ${BACKUPPATH}/mysql-dumps
echo "Base strukture created under ${BACKUPPATH}."
echo " "
sed 's:REPLACEMEPATH:'${BACKUPPATH}':g' ./orig_mysql_multi_backup.sh>${BACKUPPATH}/bin/mysql_multi_backup.sh
echo " "
############################
# Make the first Conf File #
############################
echo " "
echo "Want to create your first Backup Conf File? (y/n): "
while read -n 1 -r
do
  case $REPLY in
    y|Y) makefirstconfig ;;
    n|N) echo "Ok. You will need to generate your first conf file on your own before the script is ready to run. \n \n"; donedone ;;
    *)   echo "Want to create your first Backup Conf File? (y/n): "
         continue ;;
  esac
  break
done

#
# this is the Alpha Part about the Alpha
#
# give echo on setting up a cronjob and a reminder on using ssh keys
#
