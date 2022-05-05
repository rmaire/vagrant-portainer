Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define "first" do |first|
    first.vm.box = "ubuntu/jammy64"
    first.vm.hostname = "first.mycloud.local"
    first.hostmanager.aliases = %w(dashboard.mycloud.local)
    first.vm.network "private_network", ip: "192.168.56.20"

    first.vm.provider "virtualbox" do |vb|
      vb.name = "firstpt"
      vb.memory = 3072
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    first.vm.provision "shell", path: "scripts/setup.sh"
    first.vm.provision "shell", path: "scripts/portainer.sh"
  end

  config.vm.define "second" do |second|
    second.vm.box = "ubuntu/jammy64"
    second.vm.hostname = "second.mycloud.local"
    second.vm.network "private_network", ip: "192.168.56.30"

    second.vm.provider "virtualbox" do |vb|
      vb.name = "secondpt"
      vb.memory = 3072
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    second.vm.provision "shell", path: "scripts/setup.sh"
    config.vm.provision "shell", path: "scripts/rundeck.sh", args: ["192.168.56.30"]
  end

  config.vm.define "third" do |third|
    third.vm.box = "ubuntu/jammy64"
    third.vm.hostname = "third.mycloud.local"
    third.vm.network "private_network", ip: "192.168.56.40"

    third.vm.provider "virtualbox" do |vb|
      vb.name = "thirdpt"
      vb.memory = 3072
      vb.cpus = 1
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    third.vm.provision "shell", path: "scripts/setup.sh"
  end
end
