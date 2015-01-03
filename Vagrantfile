# -*- mode: ruby -*-
# vi: set ft=ruby :

SKIN_NAME = "myskin"

Vagrant.configure("2") do |config|

  # use ubuntu 14.04
  config.vm.box = "trusty64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  # setup a local hostname for this machine
  config.vm.hostname = 'askbot.dev'

  # set the local network address for this vm
  config.vm.network :private_network, ip: "192.168.50.60"

  # sync the skin directory
  config.vm.synced_folder "skin/", File.join("/home/vagrant/ab/askbot/skins", SKIN_NAME)

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "init.pp"
  end

  
  # Fix for slow external network connections
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
end
