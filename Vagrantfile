Vagrant.configure("2") do |config|
    config.vm.box = "trusty64"
    config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    config.ssh.forward_agent = true
    config.vm.network :private_network, ip: "192.168.91.11"
    config.vm.provider "virtualbox" do |v|
        v.name = "devbox"
        v.customize ["modifyvm", :id, "--memory", "2048"]
        # v.customize ["modifyvm", :id, "--cpuexecutioncap","90"]
        # v.customize ["modifyvm", :id, "--cpus",4]
        # v.customize ["modifyvm", :id, "--nictype1", "virtio"]
        # v.customize ["modifyvm", :id, "--nictype2", "virtio"]
        # v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        # v.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
        # v.auto_nat_dns_proxy = false
    end
    config.vm.provision "shell", path: "setup.sh"
    config.vm.provision "shell", path: "provision.sh"
end
