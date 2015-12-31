# Install packages
node['magento']['packages'].each do |pkg|
  package pkg do
    action :upgrade
  end
end

# Install apache modules
node['magento']['apache_modules'].each do |m|
  execute "Enable apache module #{m}" do
    command "a2enmod #{m}"
  end
end

# Install php modules
node['magento']['php5_modules'].each do |m|
  execute "Enable php module #{m}" do
    command "php5enmod #{m}"
  end
end

# Add known hosts
node['magento']['known_hosts'].each do |known_host|
  ssh_known_hosts_entry known_host
end


include_recipe "magento::instances"
include_recipe "magento::users_groups"

execute "Restart apache" do
  command "service apache2 restart"
end