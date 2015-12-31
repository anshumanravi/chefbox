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
echo "Running Chef..."
echo "---------------"
echo
/etc/chefbox/provision.sh || { echo >&2 "Chef provisioning failed"; exit 1; }

echo ""
echo "What's next?"
echo "------------"
echo ""
echo "(0. Log in to this machine if you're not already here: 'vagrant ssh' or use Putty to connect to 127.0.0.1, port 2222)"
echo "1. Go to /etc/chefbox/data_bags/magento-sites/ and create one or more project json files. Look at 'site.json.example' for an example"
echo "2. Run provisioning again:"
echo "    sudo /etc/chefbox/provision.sh"
echo "3. Copy the contents of /var/www/hosts.hosts and paste it into you host system's host file (Windows: 'C:\\Windows\\System32\\drivers\\etc\\hosts')"
echo "4. Follow the instructions on the login screen (log out and log in again) for more information on how to install/update a build package"
echo ""
echo "Have a great day!"
echo ""
