PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %{$reset_color%}%{$fg[yellow]%}$(git_prompt_info)%{$fg_bold[blue]%}➥  %{$reset_color%}'

RPS1='$(vi_mode_prompt_info) ${return_code}'
MODE_INDICATOR="%{$fg_bold[yellow]%}[NORMAL]%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=") "
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
