- Requirements  
    - sudo apt-get install neofetch build-essential git curl xclip wmctrl xsel autojump zsh htop  
    - tmux version 2.8  
        - https://github.com/tmux/tmux/wiki  
        - sudo apt-get install libevent-dev libncurses5-dev  
    - (deprecated) terminator  
        - sudo apt-get install terminator  
    - (deprecated) rxvt-unicode 9.22  
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
    - i3 4.16.1:  
        - sudo apt-get install i3 py3status  
        - sudo apt-get install gdm3  
        - sudo apt-get install libnotify-bin  
        - sudo apt-get install xautolock  
        sudo apt-get install libxcb1-dev 
sudo apt-get install libxcb-keysyms1-dev 
sudo apt-get install libxcb-util0-dev 
sudo apt-get install libxcb-icccm4-dev 
sudo apt-get install libyajl-dev 
sudo apt-get install libstartup-notification0-dev  
sudo apt-get install libxcb-randr0-dev 
sudo apt-get install libev-dev 
sudo apt-get install libxcb-xinerama0-dev 
sudo apt-get install libpango1.0-dev 
sudo apt-get install libxcursor-dev 
sudo apt-get install libxcb-cursor-dev
sudo apt-get install libxcb-xkb-dev
sudo apt-get install libxkbcommon-dev
sudo apt-get install libxkbcommon-x11-dev
        - polybar 3.3.0  
            - https://github.com/jaagr/polybar/wiki/Compiling  
            - sudo apt-get install build-essential git cmake cmake-data pkg-config libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libiw-dev libnl-genl-3-dev  
            - mkdir build && cd build && cmake .. && make && make install (TODO: install with stow)  
            - sudo apt-get install jq  
            - sudo pip3 install i3ipc  
            - git clone https://github.com/stark/siji && cd siji && ./install.sh  
                - sudo ln -s /etc/fonts/conf.avail/70-force-bitmaps.conf /etc/fonts/conf.d/  
                - sudo unlink /etc/fonts/conf.d/70-no-bitmaps.conf # For disabling no-bitmap setting  
                - sudo apt-get install unifont  
        - betterlock
            - i3lock-color
                - sudo apt install bc imagemagick libjpeg-turbo8-dev libpam0g-dev libxcb-composite0 libxcb-composite0-dev libxcb-image0-dev libxcb-randr0 libxcb-util-dev libxcb-xinerama0 libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-x11-dev feh libev-dev  
                - git clone https://github.com/PandorasFox/i3lock-color.git  
                - cd i3lock-color  
                - autoreconf -i  
                - ./configure --prefix=/usr/local  
                - sudo make install prefix=/usr/local/stow/i3lock-color  
                - cd /usr/local/stow  
                - sudo stow i3lock-color  
            - curl -o betterlockscreen https://raw.githubusercontent.com/pavanjadhaw/betterlockscreen/master/betterlockscreen  
            - chmod +x betterlockscreen  
            - sudo mkdir -p /usr/local/stow/betterlockscreen/bin  
            - sudo cp betterlockscreen /usr/local/stow/betterlockscreen/bin  
            - cd /usr/local/stow  
            - sudo stow betterlockscreen  
            - betterlockscreen -u ~/.config/i3/wallpapers/tarantino.jpg  
        - simple simple-mtpfs 0.3.0  
            - sudo apt-get install libfuse-dev libmtp-dev  
            - https://github.com/phatina/simple-mtpfs/releases/tag/simple-mtpfs-0.3.0  
            - ./autogen.sh  
            - mkdir build  
            - stow...  


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
