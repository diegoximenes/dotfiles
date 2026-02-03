# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

################################################################################
# general
################################################################################

setopt PROMPT_SUBST

################################################################################
# antigen
################################################################################

source /usr/share/zsh/share/antigen.zsh

antigen use oh-my-zsh

# oh-my-zsh plugins
antigen bundle git
antigen bundle git-extras
antigen bundle vi-mode

export FZF_CTRL_T_COMMAND='find .' # includes hidden files on search
export FZF_DEFAULT_OPTS='-e'
antigen bundle fzf

antigen bundle command-not-found

antigen bundle zoxide

export WORKON_HOME=$HOME/python_virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
antigen bundle virtualenvwrapper

# other plugins
antigen theme romkatv/powerlevel10k

antigen bundle hlissner/zsh-autopair
antigen bundle zsh-users/zsh-syntax-highlighting

export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
export NVM_AUTO_USE=true
antigen bundle lukechilds/zsh-nvm

antigen apply

# source powerlevel10k config after sourcing it with antigen
source ~/.p10k.zsh

################################################################################
# general exports
################################################################################

export KEYTIMEOUT=1 # default is bigger, in case of problems remove this line
export EDITOR="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export PAGER=bat

# go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# yarn
export PATH="$PATH:$HOME/.yarn/bin"

################################################################################
# bindkey
################################################################################

bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PgUp
bindkey "\e[6~" end-of-history # PgDn
bindkey "\e[3~" delete-char # Delete
bindkey "\e[2~" vi-cmd-mode # Insert
# keypad
bindkey "\eOM" accept-line # Enter
bindkey "\eOE" vi-cmd-mode # 5
bindkey -s "\eOo" "/" # /
bindkey -s "\eOj" "*" # *
bindkey -s "\eOm" "-" # -
bindkey -s "\eOk" "+" # +
# F*
bindkey "\eOP" vi-cmd-mode # F1
bindkey "\eOQ" vi-cmd-mode # F2
bindkey "\eOR" vi-cmd-mode # F3
bindkey "\eOS" vi-cmd-mode # F4

################################################################################
# commands
################################################################################

wifi_list() {
    nmcli device wifi list
}

wifi_connect() {
    local ssid="$1"
    local password="$2"
    nmcli device wifi connect "$ssid" password "$password"
}

interface_list() {
    nmcli device
}

clip() {
    xclip -selection clipboard && xclip -o -selection clipboard
}

mkvirtualenv_jupyter() {
    local env="$1"
    mkvirtualenv "$env"
    pip install pynvim ipykernel
    python -m ipykernel install --user --name="$env"
}

rmvirtualenv_jupyter() {
    local env="$1"
    if [[ "$VIRTUAL_ENV" == "$WORKON_HOME/$env" ]]; then
        deactivate
    fi
    rmvirtualenv "$env"
    jupyter kernelspec uninstall "$env"
}

ssh_agent() {
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_ed25519"
}

ssh_agent_status() {
    keys=$(ssh-add -l 2>&1)
    if [[ "$keys" != "Could not open a connection to your authentication agent." ]] && [[ "$keys" != "The agent has no identities." ]]; then
        echo "(ssh) "
    fi
}

screen_always_on() {
    xset s off -dpms
}

################################################################################
# the fuck
################################################################################

# eval $(thefuck --alias) is too slow
# so adds it output here directly
fuck () {
    TF_PYTHONIOENCODING=$PYTHONIOENCODING;
    export TF_SHELL=zsh;
    export TF_ALIAS=fuck;
    TF_SHELL_ALIASES=$(alias);
    export TF_SHELL_ALIASES;
    TF_HISTORY="$(fc -ln -10)";
    export TF_HISTORY;
    export PYTHONIOENCODING=utf-8;
    TF_CMD=$(
        thefuck THEFUCK_ARGUMENT_PLACEHOLDER $@
    ) && eval $TF_CMD;
    unset TF_HISTORY;
    export PYTHONIOENCODING=$TF_PYTHONIOENCODING;
    test -n "$TF_CMD" && print -s $TF_CMD
}

################################################################################
# zle
################################################################################

normal_cursor='\e[1 q'
insert_cursor='\e[5 q'

# change cursor shape for different vi modes
zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne "$normal_cursor"
    elif [[ ${KEYMAP} == main ]] ||
      [[ ${KEYMAP} == viins ]] ||
      [[ ${KEYMAP} = '' ]] ||
      [[ $1 = 'beam' ]]; then
        echo -ne "$insert_cursor"
    fi
}
zle -N zle-keymap-select

zle-line-init() {
    # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    zle -K viins
    echo -ne "$insert_cursor"
}
zle -N zle-line-init

# set startup cursor
echo -ne "$insert_cursor"

# set new prompt cursor
preexec() {
    echo -ne "$insert_cursor"
}

################################################################################
# aliases
################################################################################

alias j='z'
alias t="tig"
alias ls="eza"
alias l="eza -lah --git"
alias vraw="nvim --noplugin"
alias v="nvim -p"
alias vi="nvim -p"
alias vim="nvim -p"
alias nvim="nvim -p"
alias s="sudo "
alias sudo="sudo "
alias r="ranger"
alias c="clear"
alias f="fuck"
alias p="sudo pacman"
alias p_overwrite='sudo pacman --overwrite "*"'
alias yay_overwrite='yay --overwrite "*"'
alias cpp="rsync -ah --progress"
alias mvp="rsync -ah --progress --remove-source-files"
alias dev="lsblk -plo NAME,TYPE,RM,SIZE,MOUNTPOINT,VENDOR"
# avoid problems when opening ipython in virtualenvs
alias ipython="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
alias diff="difft"
trans_cmd=" trans -show-original n -show-original-phonetics n -show-translation-phonetics n -show-prompt-message n -show-languages n -show-original-dictionary n -show-dictionary n -show-alternatives y"
alias trans_pt="$trans_cmd -s pt -t en"
alias trans_en="$trans_cmd -s en -t pt"
alias dic="bash ~/.scripts/dic.sh"
alias smem="smem -a -k -r -s pss -c 'pid name user vss rss pss swap'"
alias iptraf="sudo iptraf-ng"
alias images_to_pdf="convert" # images_to_pdf image1.png image2.png ... file.pdf
alias greenclip_clear="pkill greenclip && greenclip clear && nohup greenclip daemon > /dev/null 2>&1 &"
alias sync_arch_databases="sudo pacman -Syy"
alias myprogress="watch progress -q"
alias json_format="bash ~/.scripts/json_format.sh"
alias gsudo="sudo git -c include.path=$HOME/.gitconfig"
# git aliases
alias gs="git status"
alias gam="git commit --amend"
alias gc="git commit -m"
alias gch="git checkout"
alias gchm="git checkout $(git_main_branch)"
alias gpd="git pushdefault"
alias gp="git pull"
alias gr="git restore --staged"
alias cop="gh copilot"
