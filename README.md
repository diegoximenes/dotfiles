# dotfiles

- install  
  - curl <https://raw.githubusercontent.com/diegoximenes/dotfiles/master/install.sh> --output /tmp/install.sh
  - bash /tmp/install.sh
  - reboot
  - create ssh key and add to github
  - bash ~/Documents/dotfiles/bootstrap_after_reboot.sh

- microcode  
  - packages/pkglist.txt includes intel-ucode. If using an AMD processor change to amd-ucode.  

- tmux  
  - installing plugins: prefix + I  
  - uninstalling plugins: remove plugin line from tmux.conf && prefix + alt + u  
  - to reset tmux configurations: tmux kill-server  

- pull  
  - git pull  
  - git submodule update --init --remote  
  - git submodule foreach 'git submodule update --init --recursive'  
