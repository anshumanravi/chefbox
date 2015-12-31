
node.default['magento']['main_users'] << node['magento']['main_user']

# put all users in node['magento']['main_groups'] to all groups in node['magento']['main_groups']
node['magento']['main_groups'].each do |group_name|
  group group_name do
    action :modify
    members node['magento']['main_users']
    append true
  end
end