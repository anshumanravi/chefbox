Chef::Log.info("Writing motd");

execute "Remove all existing motd" do
  user 'root'
  command "chmod -x /etc/update-motd.d/*"
end

motd = ""

motd << '  ___  ___                       _         ' + "\n"
motd << '  |  \/  |                      | |        ' + "\n"
motd << '  | .  . | __ _  __ _  ___ _ __ | |_ ___   ' + "\n"
motd << '  | |\/| |/ _` |/ _` |/ _ | ._ \| __/ _ \  ' + "\n"
motd << '  | |  | | (_| | (_| |  __| | | | || (_) | ' + "\n"
motd << '  \_|  |_/\__,_|\__, |\___|_| |_|\__\___/  ' + "\n"
motd << '                 __/ |                     ' + "\n"
motd << '                |___/                      ' + "\n"

motd << "\n"

sites = data_bag(node['magento']['magento_instances_databag_name'])
sites.each do |site|
  opts = data_bag_item(node['magento']['magento_instances_databag_name'], site)

  if opts.key?("motd")
    motd << "\n"
    opts["motd"].each do |line|
      motd << "#{line}\n"
    end
    motd << "\n"
  end

end

file '/etc/motd' do
  content motd
end