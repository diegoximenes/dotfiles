- Requirements  
-   - sudo apt-get install xclip wmctrl xsel autojump zsh  
    - tmux version 2.5  
    - oh-my-zsh  

- pull  
    - git pull && git submodule init && git submodule update  

- tmux  
    - don't include plugin directory on git since tpm doesn't add git submodules  
    - installing plugins: prefix + I  
    - uninstalling plugins: remove plugin line from tmux.conf && 
    prefix + alt + u  

- rxvt-unicode-256color:  
    - in case that the maximized window is not fully maximized in KDE: 
    Right Click on 
    window title bar > More Actions > Special Applications Settings > Size and 
    Position > Obey geometry restrictions > Choose Force and leave check mark 
    to No. Voila! all size problems go away.  
    - to change icon: right click on "Application Menu" -> "Edit Applications",
      find urxvt in "Utilities" and change icon to the following file: 
      /usr/share/icons/Humanity/apps/32/terminal.svg  
