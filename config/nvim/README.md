- ale:  
    - scala  
        - http://www.scalastyle.org/command-line.html  
            - update checker in directory ~/.vim/syntax_checkers/scala  

- snippets:  
    - if want to modify snippets: copy from 
    ~/.local/share/nvim/plugged/vim-snippets/UltiSnips/lang.snippets to ~/.config/nvim/mysnippets and 
    then modify  

- eclim (NOT PORTED TO ARCH):  
    - install: http://eclim.org/install.html  
        - sudo apt-get install openjdk-8-jdk  
        - install Scala IDE for Eclipse:  
            - tar -xzvf scala-SDK-4.7.0-vfinal-2.12-linux.gtk.x86_64.tar.gz -C 
            ~/.vim  
        - mkdir ~/.vim/bundle/eclim  
        - bash eclim_2.7.2.bin  
    - usage:  
        - ~/.vim/eclipse/eclimd  
        - in vim: :ProjectCreate path_to_project -n scala  
        - Go to definition: :ScalaSearch  
