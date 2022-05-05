# install hostmanager plugin ad administrator/root:
# vagrant plugin install vagrant-hostmanager

Vagrant.configure("2") do |config|

  config.ssh.insert_key = false

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define "first" do |first|
    first.vm.box = "ubuntu/jammy64"
    first.vm.network "private_network", ip: "192.168.56.20"
    first.vm.hostname = "first.mycloud.local"

    first.vm.provider "virtualbox" do |vb|
      vb.name = "first"
      vb.memory = 2048
      vb.cpus = 3
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    first.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
    first.vm.provision "shell", path: "scripts/setup.sh"
    #first.vm.provision "shell", path: "scripts/portainer.sh"

  end

  config.vm.define "second" do |second|
    second.vm.box = "ubuntu/jammy64"
    second.vm.network "private_network", ip: "192.168.56.30"
    second.vm.hostname = "second.mycloud.local"

    second.vm.provider "virtualbox" do |vb|
      vb.name = "second"
      vb.memory = 2048
      vb.cpus = 3
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    second.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
    second.vm.provision "shell", path: "scripts/setup.sh"
  end

  config.vm.define "third" do |third|
    third.vm.box = "ubuntu/jammy64"
    third.vm.network "private_network", ip: "192.168.56.40"
    third.vm.hostname = "third.mycloud.local"

    third.vm.provider "virtualbox" do |vb|
      vb.name = "third"
      vb.memory = 2048
      vb.cpus = 3
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    third.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
    third.vm.provision "shell", path: "scripts/setup.sh"
  end

  config.vm.define "fourth" do |fourth|
    fourth.vm.box = "ubuntu/jammy64"
    fourth.vm.network "private_network", ip: "192.168.56.50"
    fourth.vm.hostname = "fourth.mycloud.local"

    fourth.vm.provider "virtualbox" do |vb|
      vb.name = "fourth"
      vb.memory = 2048
      vb.cpus = 3
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    fourth.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
    fourth.vm.provision "shell", path: "scripts/setup.sh"
  end

  config.vm.define "fifth" do |fifth|
    fifth.vm.box = "ubuntu/jammy64"
    fifth.vm.network "private_network", ip: "192.168.56.60"
    fifth.vm.hostname = "fifth.mycloud.local"

    fifth.vm.provider "virtualbox" do |vb|
      vb.name = "fifth"
      vb.memory = 2048
      vb.cpus = 3
      vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    fifth.vm.provision :shell, :inline => "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;", run: "always"
    fifth.vm.provision "shell", path: "scripts/setup.sh"
  end

  config.vm.define "tools" do |tools|
    tools.vm.box = "ubuntu/jammy64"
    tools.vm.network "private_network", ip: "192.168.56.80"
    tools.vm.hostname = "tools.mycloud.local"

    tools.vm.provider "virtualbox" do |vb|
      vb.name = "tools"
      vb.memory = 1024
      vb.cpus = 1
    end

    tools.vm.provision "shell", path: "scripts/setup.sh"

    tools.vm.provision "shell", inline: <<-EOF
      cp /vagrant/keys/insecure_private_key /home/vagrant/.ssh/
      chmod 700 /home/vagrant/.ssh/insecure_private_key

      hashi-up consul install \
        --local \
        --skip-enable \
        --skip-start \
        --client-addr 0.0.0.0

      hashi-up nomad install \
        --local \
        --skip-enable \
        --skip-start
    EOF

    #tools.vm.provision "shell", path: "scripts/cluster.sh"
  end
end
