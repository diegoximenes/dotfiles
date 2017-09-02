- Requirements  
    - sudo apt-get install xclip wmctrl xsel autojump zsh  
    - tmux version 2.5  
        - https://github.com/tmux/tmux/wiki  
        - sudo apt-get install libevent-dev libncurses5-dev  
    - rxvt-unicode 9.22  
        - http://software.schmorp.de/pkg/rxvt-unicode.html  
        - sudo apt-get install libperl-dev libx11-dev libxft-dev  
        - ./configure --enable-everything --enable-256-color --enable-xft  
    - oh-my-zsh  
        - https://github.com/robbyrussell/oh-my-zsh  

- clone  
    - git clone --recursive https://diegoximenes@bitbucket.org/diegoximenes/dotfiles.git  
    - bash install.sh  

- pull  
    - git pull && git submodule init && git submodule update  

- zsh  
    - chsh -s $(which zsh)  

- tmux  
    - don't include plugin directory on git since tpm doesn't add git submodules  
    - installing plugins: prefix + I  
    - uninstalling plugins: remove plugin line from tmux.conf && 
    prefix + alt + u  

- rxvt-unicode:  
    - in case that the maximized window is not fully maximized in KDE: 
    Right Click on 
    window title bar > More Actions > Special Applications Settings > Size and 
    Position > Obey geometry restrictions > Choose Force and leave check mark 
    to No.  
    - to change icon: right click on "Application Menu" -> "Edit Applications",
    add "New Item" with command urxvt. Change icon to 
    /usr/share/icons/Humanity/apps/32/terminal.svg  
