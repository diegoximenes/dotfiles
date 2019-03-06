- install  
    - git clone --recurse-submodules https://diegoximenes@bitbucket.org/diegoximenes/dotfiles.git ~/dotfiles  
    - bash bootstrap.sh  
    - reboot  

- tmux  
    - don't include plugin directory on git since tpm doesn't add git submodules  
    - installing plugins: prefix + I  
    - uninstalling plugins: remove plugin line from tmux.conf && prefix + alt + u  
    - to reset tmux configurations: tmux kill-server  

- pull  
    - git pull  
    - git submodule update --init --remote  
    - git submodule foreach 'git submodule update --init --recursive'    
