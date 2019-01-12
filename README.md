- Requirements  
    - sudo apt-get install build-essential git curl xclip wmctrl xsel autojump zsh htop  
    - tmux version 2.8  
        - https://github.com/tmux/tmux/wiki  
        - sudo apt-get install libevent-dev libncurses5-dev  
    - terminator  
        - sudo apt-get install terminator  
    - rxvt-unicode 9.22  
        - http://software.schmorp.de/pkg/rxvt-unicode.html  
        - sudo apt-get install libperl-dev libx11-dev libxft-dev  
        - ./configure --enable-everything --enable-256-color --enable-xft  
    - oh-my-zsh  
        - https://github.com/robbyrussell/oh-my-zsh  
    - python configs  
        - sudo apt-get install python-pip python3-pip  
        - sudo pip2 install --upgrade pip  
        - sudo pip3 install --upgrade pip  
        - sudo pip2 install virtualenvwrapper  
        - sudo pip3 install virtualenvwrapper  
    - the fuck:  
        - sudo pip3 install thefuck  
    - fzf:  
        - https://github.com/junegunn/fzf  

- clone  
    - git clone --recursive https://diegoximenes@bitbucket.org/diegoximenes/dotfiles.git ~/Documents/dotfiles  
    - bash install.sh  

- pull  
    - git pull  
    - git submodule update --init --remote  
    - git submodule foreach 'git submodule update --init --recursive'  

- tmux  
    - don't include plugin directory on git since tpm doesn't add git submodules  
    - installing plugins: prefix + I  
    - uninstalling plugins: remove plugin line from tmux.conf && 
    prefix + alt + u  
    - to reset tmux configurations: tmux kill-server  

- rxvt-unicode:  
    - in case that the maximized window is not fully maximized in KDE: 
    Right Click on 
    window title bar > More Actions > Special Applications Settings > Size and 
    Position > Obey geometry restrictions > Choose Force and leave check mark 
    to No.  
    - to change icon: right click on "Application Menu" -> "Edit Applications",
    add "New Item" with command urxvt. Change icon to 
    /usr/share/icons/Humanity/apps/32/terminal.svg    
