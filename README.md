- install  
    - mkdir -p ~/Documents  
    - git clone --recurse-submodules git@github.com:diegoximenes/dotfiles.git ~/Documents/dotfiles  
    - bash bootstrap.sh --install  
    - reboot  
    - bash bootstrap_after_reboot.sh  

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
