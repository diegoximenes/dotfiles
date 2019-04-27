################################################################################
# exports
################################################################################

export KEYTIMEOUT=1 # default is bigger, in case of problems remove this line
export EDITOR="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export FZF_DEFAULT_COMMAND='find .' # includes hidden files on search
export ZSH=$HOME/.oh-my-zsh

# adds global yarn bin path to PATH
if [[ -x "$(which yarn)" ]]; then
    path_to_yarn_bins=$(yarn global bin 2> /dev/null)
    export PATH=$PATH:$path_to_yarn_bins
fi

# virtualenvwrapper
export WORKON_HOME=$HOME/python_virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

# color in man pages
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan

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

mytop() {
    local cmd=$1
    if [[ "$cmd" == "" ]]; then
        top
    else
        local pids=$(pgrep -d',' -f $cmd)
        if [[ "$pids" == "" ]]; then
            echo "command pattern not found."
        else
            top -p $pids
        fi
    fi
}

clip() {
    xclip -selection clipboard && xclip -o -selection clipboard
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
