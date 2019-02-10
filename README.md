- Requirements  
    - useful softwares  
        - sudo apt-get install zathura neofetch build-essential git curl xclip wmctrl xsel autojump zsh htop  
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
    - the fuck  
        - sudo pip3 install thefuck  
    - fzf  
        - https://github.com/junegunn/fzf  
    - i3 4.16.1  
        - to build from source
            - sudo apt-get install libxcb1-dev libxcb-keysyms1-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev  libxcb-randr0-dev libev-dev libxcb-xinerama0-dev libpango1.0-dev libxcursor-dev libxcb-cursor-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev  
        - useful softwares  
            - sudo apt-get install dunst gdm3 libnotify-bin xautolock deepin-screenshot  
        - polybar 3.3.0  
            - https://github.com/jaagr/polybar/wiki/Compiling  
            - sudo apt-get install unifont jq build-essential git cmake cmake-data pkg-config libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libiw-dev libnl-genl-3-dev  
            - mkdir build && cd build && cmake .. && make && make install (TODO: install with stow)  
            - sudo pip3 install i3ipc  
            - git clone https://github.com/stark/siji && cd siji && ./install.sh  
                - sudo ln -s /etc/fonts/conf.avail/70-force-bitmaps.conf /etc/fonts/conf.d/  
                - sudo unlink /etc/fonts/conf.d/70-no-bitmaps.conf  
        - betterlock
            - i3lock-color
                - sudo apt-get install bc imagemagick libjpeg-turbo8-dev libpam0g-dev libxcb-composite0 libxcb-composite0-dev libxcb-image0-dev libxcb-randr0 libxcb-util-dev libxcb-xinerama0 libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-x11-dev feh libev-dev  
                - git clone https://github.com/PandorasFox/i3lock-color.git  
                - cd i3lock-color  
                - autoreconf -i  
                - stow like install  
            - curl -o betterlockscreen https://raw.githubusercontent.com/pavanjadhaw/betterlockscreen/master/betterlockscreen  
            - chmod +x betterlockscreen  
            - sudo mkdir -p /usr/local/stow/betterlockscreen/bin  
            - sudo cp betterlockscreen /usr/local/stow/betterlockscreen/bin  
            - cd /usr/local/stow  
            - sudo stow betterlockscreen  
            - betterlockscreen -u ~/.config/i3/wallpapers/tarantino.jpg  

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
