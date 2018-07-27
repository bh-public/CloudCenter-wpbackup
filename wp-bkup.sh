#!/bin/bash -x
exec > >(tee -a /var/tmp/wp-bkup_$$.log) 2>&1

. /usr/local/osmosix/etc/.osmosix.sh
. /usr/local/osmosix/etc/userenv
. /usr/local/osmosix/service/utils/cfgutil.sh
. /usr/local/osmosix/service/utils/agent_util.sh
cd ~
REPOSITORY_URL=$REPOSITORY_URL
echo "Username: $(whoami)"
echo "Working Directory: $(pwd)"

env

yum install zip unzip -y

cd /var/www

sudo zip -r ~/wordpressbkup.zip *
#export SSHPASS='$repoPwd'
export SSHPASS=$repoPwd

sudo rpm -Uvh "http://$REPOSITORY_URL/apps/wordpress/localMigrate/wp_local/sshpass-1.05-1.el6.rf.x86_64.rpm"

sshpass -e ssh -o StrictHostKeyChecking=no $repoUser@$repoServer "mkdir -p /repo/migration/$CliqrDeploymentId" 
sshpass -e scp -o StrictHostKeyChecking=no ~/wordpressbkup.zip $repoUser@$repoServer:/repo/migration/$CliqrDeploymentId

sudo rm ~/wordpressbkup.zip
