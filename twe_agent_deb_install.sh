#!/bin/bash

twe_agent_binary = "tweagent_8.9_amd64.deb"

echo "Installing $twe_agent_binary Agent"
dpkg -i $twe_agent_binary

sleep  10

echo "Creating directories"
mkdir /usr/local/tripwire/te/agent/tmp
mkdir /usr/local/tripwire/te/agent/data/log

echo "Copying over additional files"
cp agent.properties /usr/local/tripwire/te/agent/data/config/
sed -i "s/hostname=\w*\-\w*\.DOMAIN\.COM/hostname=\U`hostname -f`/" /usr/local/tripwire/te/agent/data/config/agent.properties

mv /usr/local/tripwire/te/agent/data/security /usr/local/tripwire/te/agent/data/security.original
cp -r security/ /usr/local/tripwire/te/agent/data/security

cp wrapper-license.conf /usr/local/tripwire/te/agent/bin/

echo "Executing conftool.sh"
/usr/local/tripwire/te/agent/bin/conftool.sh

sleep 1

$twe_agent_secret = "123456"
echo "Syncing passphrase"
/usr/local/tripwire/te/agent/bin/tetool setchannelpass $twe_agent_secret $twe_agent_secret

sleep 2

echo "Setting up tripwire service in /etc/init.d"
cp tripwire /etc/init.d/
update-rc.d tripwire defaults

sleep 2

echo "Starting Tripwire Agent"
/usr/local/tripwire/te/agent/bin/twdaemon start

sleep 3

echo "Check Status of Tripwire Agent"
/usr/local/tripwire/te/agent/bin/twdaemon status
