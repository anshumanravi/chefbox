#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "Please run this script as root"
    exit 1
fi

if ! hash git 2>/dev/null; then
    apt-get -y update
    apt-get -y install git
fi

echo
echo "Cloning cookbook..."
echo "--------------------------------------"
echo

if [ ! -d /etc/chefbox ] || [ ! -f /etc/chefbox/Berksfile ] ; then
    git clone https://github.com/anshumanravi/chefbox.git /etc/chefbox || { echo >&2 "Cloning failed"; exit 1; }
else 
    cd /etc/chefbox && git pull
fi

if [ ! -f /opt/chefdk/bin/chef ] || [ "$(/opt/chefdk/bin/chef --version)" != "Chef Development Kit Version: 0.4.0" ] ; then
    echo
    echo "Installing ChefDK (includes Berkshelf)..."
    echo "-----------------------------------------"
    echo
    wget -q https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.4.0-1_amd64.deb -O /tmp/chefdk.deb || { echo >&2 "Downloading ChefDK package failed"; exit 1; }
    dpkg -i /tmp/chefdk.deb || { echo >&2 "Installing ChefDK failed"; exit 1; }
fi

echo
echo "Fetching dependencies via Berkshelf..."
echo "--------------------------------------"
echo
if [ -f /etc/chefbox/Berksfile.lock ] ; then rm /etc/chefbox/Berksfile.lock; fi
if [ -d ~/.berkshelf ] ; then rm -rf ~/.berkshelf; fi
if [ -d /etc/chefbox/cookbooks ] ; then rm -rf /etc/chefbox/cookbooks; fi
cd /etc/chefbox && berks vendor /etc/chefbox/cookbooks || { echo >&2 "Installing berkshelf dependencies failed"; exit 1; }

echo
echo "Rsyncing guest to host(/var/www to /vagrant/htdocs)"
echo "--------------------------------------"
echo
if [ ! -d /vagrant/htdocs ]; then mkdir /vagrant/htdocs; fi
rsync -r /var/www/ /vagrant/htdocs/ || { echo >&2 "Can not synced /vagrant/htdocs to /var/www "; exit 1; }

