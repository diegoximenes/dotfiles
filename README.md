# dotfiles

- install  
  - cd /tmp
  - curl <https://raw.githubusercontent.com/diegoximenes/dotfiles/master/install.sh> --output install.sh
  - bash install.sh
  - reboot
  - add ssh key to github
  - bash ~/Documents/dotfiles/bootstrap_after_reboot.sh

- microcode  
  - packages/pkglist.txt includes intel-ucode. If using an AMD processor change to amd-ucode.  

- tmux  
  - don't include plugin directory on git since tpm doesn't add git submodules  
  - installing plugins: prefix + I  
  - uninstalling plugins: remove plugin line from tmux.conf && prefix + alt + u  
  - to reset tmux configurations: tmux kill-server  

- pull  
  - git pull  
  - git submodule update --init --remote  
  - git submodule foreach 'git submodule update --init --recursive'  
