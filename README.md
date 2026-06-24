```bash
packer init oraclelinux-10.pkr.hcl

export VBOX_LOG_DEST=nofile
packer build --only=virtualbox-iso.oraclelinux-10 -force oraclelinux-10.pkr.hcl

vagrant up --provider virtualbox
```


```bash
packer init oraclelinux-10.pkr.hcl

packer build --only=qemu.oraclelinux-10 -force oraclelinux-10.pkr.hcl
vagrant up --provider libvirt
```