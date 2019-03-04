# default is bigger, in case of problems remove this line
export KEYTIMEOUT=1

export EDITOR="nvim"
export BROWSER="google-chrome"

alias g="git"
alias v="nvim -p"
alias r="ranger"
alias c="clear"
alias f="fuck"
alias s="sudo "
alias z="zathura"
alias vim="nvim -p"
alias sudo="sudo "
alias cpp="rsync -ah --progress"
alias mvp="rsync -ah --progress --remove-source-files"
# avoid problems when opening ipython in virtualenvs
alias ipython="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias cal="cal -B 1 -A 1"

# adds global yarn bin path to PATH
if [ -x "$(which yarn)" ]; then
    path_to_yarn_bins=$(yarn global bin 2> /dev/null)
    export PATH=$PATH:$path_to_yarn_bins
fi

# virtualenvwrapper configs
export WORKON_HOME=$HOME/Documents/python_virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh

function myps {
    local cmd=$1
    local cols="ppid,stat,%cpu,%mem,etime,start,user,pid,cmd"
    if [[ "$cmd" == "" ]]; then
        ps -e -o $cols
    else
        ps -e -o $cols | head -n 1
        ps -e -o $cols | grep $cmd
    fi
}

function mytop {
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

function clip () {
    xclip -selection clipboard && xclip -o -selection clipboard
}

# color in man pages
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan

# includes hidden files on search
export FZF_DEFAULT_COMMAND='find .'

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="diegoximenes"

plugins=(git vi-mode autojump extract fuck)

source $ZSH/oh-my-zsh.sh

eval $(thefuck --alias)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
