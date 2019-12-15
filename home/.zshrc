################################################################################
# exports
################################################################################

export KEYTIMEOUT=1 # default is bigger, in case of problems remove this line
export EDITOR="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export FZF_DEFAULT_COMMAND='find .' # includes hidden files on search
export FZF_DEFAULT_OPTS='-e'
export ZSH=$HOME/.oh-my-zsh
export PAGER=nvimpager

# go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# virtualenvwrapper
export WORKON_HOME=$HOME/python_virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

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

myps() {
    local cmd=$1
    local cols="ppid,stat,%cpu,%mem,etime,start,user,pid,cmd"
    if [[ "$cmd" == "" ]]; then
        ps -e -o $cols
    else
        ps -e -o $cols | head -n 1
        ps -e -o $cols | grep $cmd
    fi
}

clip() {
    xclip -selection clipboard && xclip -o -selection clipboard
}

mkvirtualenv_jupyter() {
    local env="$1"
    mkvirtualenv "$env"
    pip install pynvim ipykernel pylint
    ipython kernel install --user --name="$env"
}

rmvirtualenv_jupyter() {
    local env="$1"
    if [[ "$VIRTUAL_ENV" == "$WORKON_HOME/$env" ]]; then
        deactivate
    fi
    rmvirtualenv "$env"
    jupyter kernelspec uninstall "$env"
}

################################################################################
# oh-my-zsh
################################################################################

ZSH_THEME="diegoximenes"

plugins=(
    git
    vi-mode
    autojump
    fuck
    fzf
    command-not-found
    zsh-syntax-highlighting
)

################################################################################
# source
################################################################################

source $ZSH/oh-my-zsh.sh
source /usr/bin/virtualenvwrapper.sh
eval $(thefuck --alias)

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
# alias
################################################################################

alias v="nvim -p"
alias vi="nvim -p"
alias vim="nvim -p"
alias s="sudo "
alias sudo="sudo "
alias r="ranger"
alias c="clear"
alias f="fuck"
alias z="zathura"
alias p="sudo pacman"
alias gl="nvim '' -c 'Gitv'"
alias cpp="rsync -ah --progress"
alias mvp="rsync -ah --progress --remove-source-files"
alias dev="lsblk -plo NAME,TYPE,RM,SIZE,MOUNTPOINT,VENDOR"
# avoid problems when opening ipython in virtualenvs
alias ipython="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias diff="diff --color=auto"
trans_cmd=" trans -show-original n -show-original-phonetics n -show-translation-phonetics n -show-prompt-message n -show-languages n -show-original-dictionary n -show-dictionary n -show-alternatives y"
alias trans_pt="$trans_cmd -s pt -t en"
alias trans_en="$trans_cmd -s en -t pt"
alias jsonpp="python -m json.tool"
