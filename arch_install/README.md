# arch install

- create bootable usb:
  - <https://www.archlinux.org/download/>
  - dd bs=4M if=path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync

- boot in UEFI mode. Disable secure boot

- partition:
  - create a GPT partition table with fdisk:
    - fdisk DISK (e.g. /dev/sda)
    - fdisk> g # creates GPT partition table
    - fdisk> w # save and quit
  - create the partitions:
    - cfdisk DISK (e.g. /dev/sda)
      - create EFI: 550M EFI System
      - create swap: Type: Linux swap
      - create filesystem: Type: Linux filesystem
    - check with lsblk

- connect wifi:
  - ip link # check devices, in this example using wlp3s0
  - ip link set wlp3s0 up
  - if using wireless:
    - systemctl start iwd
    - iwctl station wlp3s0 scan
    - iwctl station wlp3s0 get-networks
    - iwctl --passphrase PASSWD station wlp3s0 connect SSID
  - systemctl start dhcpcd@wlp3s0.service

- installing:
  - curl <https://raw.githubusercontent.com/diegoximenes/dotfiles/master/arch_install/install.sh> --output install.sh
  - bash install.sh ARCH_PART(e.g. /dev/sda3) SWAP_PART(e.g. /dev/sda2) EFI_PART(e.g. /dev/sda1) FORMAT_EFI_PART(y/n)

- configuring
  - arch-chroot /mnt
  - curl <https://raw.githubusercontent.com/diegoximenes/dotfiles/master/arch_install/configure.sh> --output /tmp/configure.sh
  - bash /tmp/configure.sh HOST_NAME USER
  - exit
  - reboot

- in case installing another OS after arch: sudo grub-mkconfig -o /boot/grub/grub.cfg
