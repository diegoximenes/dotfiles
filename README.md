- (crontab -l 2>/dev/null; echo "*/10 * * * * ~/.config/i3/scripts/low_battery.sh") | crontab -  

- install  
    - git clone --recursive https://diegoximenes@bitbucket.org/diegoximenes/dotfiles.git ~/dotfiles  
    - bash bootstrap.sh  

- tmux  
    - don't include plugin directory on git since tpm doesn't add git submodules  
    - installing plugins: prefix + I  
    - uninstalling plugins: remove plugin line from tmux.conf && prefix + alt + u  
    - to reset tmux configurations: tmux kill-server

- pull  
    - git pull  
    - git submodule update --init --remote  
    - git submodule foreach 'git submodule update --init --recursive'    
