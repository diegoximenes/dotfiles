# dotfiles

- install
  - curl <https://raw.githubusercontent.com/diegoximenes/dotfiles/master/install/install.sh> --output /tmp/install.sh
  - bash /tmp/install.sh
  - reboot
  - create ssh key and add to github
  - bash ~/Documents/dotfiles/install/bootstrap_after_reboot.sh

- update
  - zsh ~/Documents/dotfiles/install/update.sh

- microcode
  - packages/pkglist.txt includes intel-ucode. If using an AMD processor change to amd-ucode

- tmux
  - installing plugins: prefix + I
  - uninstalling plugins: remove plugin line from tmux.conf && prefix + alt + u
  - to reset tmux configurations: tmux kill-server

- virt-manager screen resolution
  - After starting VM, go to "Video" tab and change to "Virtio"
  - Open settings in guest OS and update display resolution
