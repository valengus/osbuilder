#version=OL10

# Use graphical install
graphical

# Use network installation
url --url="https://yum.oracle.com/repo/OracleLinux/OL10/baseos/latest/$basearch/"
repo --name="ol9_AppStream" --baseurl="https://yum.oracle.com/repo/OracleLinux/OL10/appstream/$basearch/"
repo --name="ol9_UEKR7" --baseurl="https://yum.oracle.com/repo/OracleLinux/OL10/UEKR8/$basearch/"

%packages
@^minimal-environment
-iwl*-firmware
python3
openssh-server
net-tools
%end

# Disable kdump service
%addon com_redhat_kdump --disable
%end

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network information
network --bootproto=dhcp --onboot=yes --activate
network --hostname=oraclelinux-10

## Disk
# Clear the Master Boot Record
zerombr

# Remove partitions
clearpart --all --initlabel

# System bootloader configuration
bootloader --location=mbr --append="crashkernel=no"

# Automatically create partitions
autopart --type=plain --nohome --nolvm --noboot --noswap --fstype=xfs

# Firstboot
firstboot --enable
reboot --eject

# System timezone
timezone Europe/Kyiv --utc

# Firewall configuration
firewall --enabled --service=ssh

# Root password
rootpw root --allow-ssh

# Enable/disable the following services
services --enabled=sshd
