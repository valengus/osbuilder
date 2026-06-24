# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  vagrant_root = File.dirname(__FILE__)
  ENV['ANSIBLE_ROLES_PATH']       = "#{vagrant_root}/ansible/roles"
  ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

  config.vm.define "oraclelinux-10" do |config|
    config.vm.box        = "oraclelinux-10"
    config.disksize.size = "20GB"
    config.vm.provider :virtualbox do |virtualbox|
      virtualbox.cpus   = 2
      virtualbox.memory = 4 * 1024
      virtualbox.gui    = true
    end
    config.vm.provider :libvirt do |libvirt|
      libvirt.cpus                 = 2
      libvirt.memory               = 4 * 1024
      libvirt.machine_virtual_size = 20
      libvirt.qemu_use_session     = false
    end
    config.vm.synced_folder ".", "/vagrant", disabled: true
    # config.vm.provision "ansible" do |ansible|
    #   ansible.playbook = "ansible/oraclelinux-10.yml"  
    # end
  end

end
