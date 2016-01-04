#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "Please run this script as root"
    exit 1
fi

echo
echo "Running Chef..."
echo "---------------"
echo
cd /etc/chefbox && chef-solo -c solo.rb -j solo.json || { echo >&2 "Chef provsioning failed"; exit 1; }


echo
echo "Rsyncing guest to host(/var/www to /vagrant/htdocs)"
echo "--------------------------------------"
echo
if [ ! -d /vagrant/htdocs ]; then mkdir /vagrant/htdocs; fi
rsync -r /var/www/ /vagrant/htdocs/ || { echo >&2 "Can not synced /vagrant/htdocs to /var/www , Please vagrant ssh and do (rsync -r /var/www/ /vagrant/htdocs/)  it manually "; exit 0; }



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