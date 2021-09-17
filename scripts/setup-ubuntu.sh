#!/bin/bash
# https://docs.vagrantup.com/v2/provisioning/shell.html

source "/vagrant/scripts/common.sh"

function setupHosts {
	echo "modifying /etc/hosts file"
        echo "127.0.0.1 node1" >> /etc/nhosts
	echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/nhosts
	echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/nhosts
	cp /etc/nhosts /etc/hosts
	rm -f /etc/nhosts
}

function setupSwap {
    # setup swapspace daemon to allow more memory usage.
    apt-get install -y swapspace
}


function installSSHPass {
	apt-get update
	apt-get install -y sshpass
}

function overwriteSSHCopyId {
	cp -f $RES_SSH_COPYID_MODIFIED /usr/bin/ssh-copy-id
}

function createSSHKey {
	echo "generating ssh key"
	ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
	cp -f $RES_SSH_CONFIG ~/.ssh
}

function setupUtilities {
    # so the `locate` command works
    apt-get install -y mlocate
    updatedb
    apt-get install -y ant
    apt-get install -y unzip
	apt-get install -y software-properties-common
	add-apt-repository -y ppa:deadsnakes/ppa
	apt-get update
    apt-get install -y python3.9 python3.9-venv python3.9-dev
	rm /usr/bin/python
	ln -s /usr/bin/python3.9 /usr/bin/python
	rm /usr/bin/python3
	ln -s /usr/bin/python3.9 /usr/bin/python3
    apt-get install -y curl apt-utils
}

function addUser () {
	echo "Adding $1 user"
	echo "U: $1"
	echo "P: $1"
	adduser $1 --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
	echo "$1:$1" | chpasswd
}

echo "setup ubuntu"

echo "setup hosts file"
setupHosts

echo "setup ssh"
installSSHPass
createSSHKey
overwriteSSHCopyId

echo "setup utilities"
setupUtilities

echo "setup swap daemon"
setupSwap

echo "Create additional super users"
addUser hdfs
usermod -aG sudo hdfs

addUser spark
usermod -aG sudo spark

echo "ubuntu setup complete"
