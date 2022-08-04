# install hostmanager plugin ad administrator/root:
# vagrant plugin install vagrant-hostmanager

# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
# ansible-playbook -i /vagrant/inventory/sample/inventory.ini --become --become-user=root /vagrant/cluster.yml -u vagrant -k
# export KUBECONFIG=$PWD/kubespray-test.conf
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

Vagrant.configure("2") do |config|

  config.ssh.insert_key = false

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define "firstk8s" do |firstk8s|
    firstk8s.vm.box = "ubuntu/focal64"
    firstk8s.vm.network "private_network", ip: "192.168.56.20"
    firstk8s.vm.hostname = "firstk8s.mycloud.local"

    firstk8s.vm.provider "virtualbox" do |vb|
      vb.name = "firstk8s"
      vb.memory = 2048
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    firstk8s.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
    firstk8s.vm.provision "shell", path: "scripts/setup.sh"
    #first.vm.provision "shell", path: "scripts/portainer.sh"

  end

  config.vm.define "secondk8s" do |secondk8s|
    secondk8s.vm.box = "ubuntu/focal64"
    secondk8s.vm.network "private_network", ip: "192.168.56.30"
    secondk8s.vm.hostname = "secondk8s.mycloud.local"

    secondk8s.vm.provider "virtualbox" do |vb|
      vb.name = "secondk8s"
      vb.memory = 2048
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    secondk8s.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
    secondk8s.vm.provision "shell", path: "scripts/setup.sh"
  end

  config.vm.define "thirdk8s" do |thirdk8s|
    thirdk8s.vm.box = "ubuntu/focal64"
    thirdk8s.vm.network "private_network", ip: "192.168.56.40"
    thirdk8s.vm.hostname = "thirdk8s.mycloud.local"

    thirdk8s.vm.provider "virtualbox" do |vb|
      vb.name = "thirdk8s"
      vb.memory = 2048
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    thirdk8s.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
    thirdk8s.vm.provision "shell", path: "scripts/setup.sh"
  end

  config.vm.define "fourthk8s" do |fourthk8s|
    fourthk8s.vm.box = "ubuntu/focal64"
    fourthk8s.vm.network "private_network", ip: "192.168.56.50"
    fourthk8s.vm.hostname = "fourthk8s.mycloud.local"

    fourthk8s.vm.provider "virtualbox" do |vb|
      vb.name = "fourthk8s"
      vb.memory = 2048
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    fourthk8s.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
    fourthk8s.vm.provision "shell", path: "scripts/setup.sh"
  end

  config.vm.define "fifthk8s" do |fifthk8s|
    fifthk8s.vm.box = "ubuntu/focal64"
    fifthk8s.vm.network "private_network", ip: "192.168.56.60"
    fifthk8s.vm.hostname = "fifthk8s.mycloud.local"

    fifthk8s.vm.provider "virtualbox" do |vb|
      vb.name = "fifthk8s"
      vb.memory = 2048
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    fifthk8s.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
    fifthk8s.vm.provision "shell", path: "scripts/setup.sh"
  end

  config.vm.define "toolsk8s" do |toolsk8s|
    toolsk8s.vm.box = "ubuntu/focal64"
    toolsk8s.vm.network "private_network", ip: "192.168.56.80"
    toolsk8s.vm.hostname = "toolsk8s.mycloud.local"

    toolsk8s.vm.provider "virtualbox" do |vb|
      vb.name = "toolsk8s"
      vb.memory = 1024
      vb.cpus = 1
    end

    toolsk8s.vm.provision "shell", path: "scripts/setup.sh"
    toolsk8s.vm.provision "shell", path: "scripts/tools.sh"

  end
end
