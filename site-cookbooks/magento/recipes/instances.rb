Chef::Log.info("Preparing Magento instances");

user 'siteuser' do
  home '/home/siteuser'
end

group 'siteuser' do
  action :create
end

ip=`ifconfig eth1 | grep "inet " | awk -F'[: ]+' '{ print $4 }'`.strip

sites = data_bag(node['magento']['magento_instances_databag_name'])
sites.each do |site|
  opts = data_bag_item(node['magento']['magento_instances_databag_name'], site)

  Chef::Log.info("Found Magento site #{opts["id"]}")

  # Create vhost
  magento_magento_vhost "#{opts["project"]}" do
    project opts["project"]
    server_name opts["server_name"]
    server_aliases opts["server_aliases"]
  end

  # databases
  if opts.key?("databases")
    opts["databases"].each do |dbname|
      magento_magento_db dbname
    end
  end
  
end