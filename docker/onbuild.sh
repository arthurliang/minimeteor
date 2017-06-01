#!/bin/sh
# This script runs only when a Docker image is being built based on aedm/minimeteor.
# MeteorUp executes a "docker run", and "onrun.sh" is executed instead of this one.

# Fail and exit if any build command fails below
set -exov

# copy source files
sudo -u user rsync -av --exclude ".git" --exclude "/app/.meteor/local" --exclude "/app/node_modules" /app /home/user/
cd /home/user/app

# Setup auth for private npm modules
if [ -n $NPM_TOKEN ]
then
  echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" >> .npmrc
fi

# set npm taobao mirror
sudo -u user /minimeteor/npmtaobao.sh

# Install NPM packages
echo [minimeteor] Installing NPM dependencies
sudo -u user meteor npm install

# Build Meteor app
echo [minimeteor] Building Meteor app
sudo -u user meteor build --directory /home/user/meteor-app

# Install NPM packages in the bundle
echo [minimeteor] Install bundle NPM dependencies
cd /home/user/meteor-app/bundle/programs/server
sudo -u user meteor npm install

# Copy Node.js executable from Meteor distribution
cp `sudo -u user meteor node -e "console.log(process.argv[0]);"` ./

# Everything we need to run the app was done by now.
# Ignore errors during cleanup.
set +exov

# Remove Meteor
echo [minimeteor] Cleaning up
rm -rf /home/user/app
rm /usr/local/bin/meteor
rm -rf ~/.meteor
rm -rf /home/user/.meteor
rm -rf /tmp

# Remove build tools and empty cache
apt-get -y --purge autoremove curl procps python g++ make git bzip2 rsync
apt-get -y clean
rm -rf /var/lib/apt/lists/*
