#!/usr/bin/env bash

#Set data
host=$1
mik_user=$2
mik_pass=$3
dest_user=$4
dest_pass=$5

#Prepare
cdate=`date +%d-%m-%Y` # System date
cmd="/system backup save name=backup; export file=backup.rsc" # command that do the preparation of backup
mkdir -p /tmp/${host} #create temp folder
temp=/tmp/${host}

#SSH create backup in mikrot
sshpass -p ${mik_pass} ssh -o "StrictHostKeyChecking no" ${mik_user}@${host} "${cmd}"
#upload backup in temp folder
sshpass -p ${mik_pass} sftp ${mik_user}@${host}:backup.backup "${temp}"
sshpass -p ${mik_pass} sftp ${mik_user}@${host}:backup.rsc "${temp}"

#WebDav create folder & upload File in OwnCloud (webdav - may be dav), BackUP - created folder before action
curl -u ${dest_user}:${dest_pass} -X MKCOL "http://hhtpaddressorip/owncloud/remote.php/webdav/BackUP/${cdate}/"
curl -u ${dest_user}:${dest_pass} -X MKCOL "http://hhtpaddressorip/owncloud/remote.php/webdav/BackUP/${cdate}/${host}/"
curl -u ${dest_user}:${dest_pass} -T ${temp}/backup.backup "http://hhtpaddressorip/owncloud/remote.php/webdav/BackUP/${cdate}/${host}/"
curl -u ${dest_user}:${dest_pass} -T ${temp}/backup.rsc "http://hhtpaddressorip/owncloud/remote.php/webdav/BackUP/${cdate}/${host}/"

#Upload File thry sftp to NAS
sshpass -p ${dest_pass} sftp -v ${dest_user}@ipnasorftpserver <<EOF  #connect to sftp
cd BackUP_Mikrot #go to folder
put -R ${temp} #copy recursiv from local file system
quit
EOF

rm -rf {} ${temp}; #delete folder and files in server
