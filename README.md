```bash
packer init oraclelinux-10.pkr.hcl

export VBOX_LOG_DEST=nofile
packer build -force oraclelinux-10.pkr.hcl
```
