packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
    vagrant = {
      version = "~> 1"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

source "qemu" "oraclelinux-10" {
  accelerator        = "kvm"
  iso_url            = "https://yum.oracle.com/ISOS/OracleLinux/OL10/u1/x86_64/OracleLinux-R10-U1-x86_64-boot.iso"
  iso_checksum       = "sha256:ef9da0d05bb7977438c5ef34fa9aa96df830c9ad0614f4b6eb8eda7f48fcd9be"
  boot_command       =  [
    "<up>", "e", "<down><down>", "<leftCtrlOn>e<leftCtrlOff>", "<spacebar>", 
    "net.ifnames=0 inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/oraclelinux-10.ks vga=792",
    "<leftCtrlOn>x<leftCtrlOff>",
  ]
  http_directory     = "http"
  boot_wait          = "10s"
  cpu_model          = "host"
  cpus               = 2
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  disk_interface     = "virtio-scsi"
  machine_type       = "q35"
  disk_compression   = false
  disk_image         = false
  disk_size          = 12 * 1024
  firmware           = ""
  format             = "qcow2"
  headless           = false
  memory             = 4 * 1024
  net_device         = "virtio-net"
  output_directory   = "output"
  shutdown_command   = "shutdown -P now"
  ssh_password       = "root"
  ssh_timeout        = "2h"
  ssh_username       = "root"
}


source "virtualbox-iso" "oraclelinux-10" {
  iso_url               = "https://yum.oracle.com/ISOS/OracleLinux/OL10/u1/x86_64/OracleLinux-R10-U1-x86_64-boot.iso"
  iso_checksum          = "sha256:ef9da0d05bb7977438c5ef34fa9aa96df830c9ad0614f4b6eb8eda7f48fcd9be"
  guest_os_type         = "Oracle_64"
  boot_command          =  [
    "<up>", "e", "<down><down>", "<leftCtrlOn>e<leftCtrlOff>", "<spacebar>", 
    "net.ifnames=0 inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/oraclelinux-10.ks vga=792",
    "<leftCtrlOn>x<leftCtrlOff>",
  ]
  http_directory        = "http"
  output_directory      = "output"
  headless              = false
  guest_additions_mode  = "disable"
  cpus                  = 2
  memory                = 4 * 1024
  disk_size             = 12 * 1024
  boot_wait             = "10s"
  format                = "ovf"
  shutdown_command      = "shutdown -P now"
  ssh_timeout           = "2h"
  ssh_password          = "root"
  ssh_username          = "root"
  vboxmanage_post       = [
    ["modifyvm", "{{.Name}}", "--cpus", 1 ],
    ["modifyvm", "{{.Name}}", "--memory", 1024 ],
  ]
}

build {
  sources = [
    "source.qemu.oraclelinux-10",
    "source.virtualbox-iso.oraclelinux-10",
  ]

  provisioner "ansible" {
    roles_path           = "./ansible/roles"
    playbook_file        = "./ansible/${source.name}.yml"
    ansible_env_vars = [
      "ANSIBLE_PIPELINING=True",
      "ANSIBLE_REMOTE_TEMP=/tmp",
      "ANSIBLE_SCP_EXTRA_ARGS=-O",
    ]
  }

  post-processors {

    post-processor "vagrant" {
      compression_level    = "9"
      keep_input_artifact  = true
      vagrantfile_template = "vagrant/${source.name}.rb"
      output               = "output/${source.name}-${source.type}-${formatdate("YYYYMMDD", timestamp())}.box"
    }

    post-processor "shell-local" {
      inline = [
        "vagrant box add --force ${source.name} output/${source.name}-${source.type}-${formatdate("YYYYMMDD", timestamp())}.box"
      ]
    }

  }
}
