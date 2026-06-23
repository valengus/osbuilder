Vagrant.configure(2) do |config|

  config.ssh.username = 'root'
  config.ssh.password = 'root'

  config.vm.box_check_update = true

  config.vm.provider 'libvirt' do |libvirt, override|
    libvirt.machine_type = 'q35'
    libvirt.disk_bus     = 'virtio'
    libvirt.driver       = "kvm"
    libvirt.video_vram   = 256
    libvirt.memory       = 2048
    libvirt.cpus         = 2
  end

  config.vm.provider :virtualbox do |virtualbox, override|
    virtualbox.customize ["modifyvm", :id, "--memory", 2048]
    virtualbox.customize ["modifyvm", :id, "--vram", 128]
    virtualbox.customize ["modifyvm", :id, "--cpus", 2]
    virtualbox.gui = true
  end

  # Disable NFS sharing (==> default: Mounting NFS shared folders...)
  config.vm.synced_folder ".", "/vagrant", disabled: true

end
