# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ "$(whoami)" = "root" ]] && return
[[ -z "$FUNCNEST" ]] && export FUNCNEST=100          # limits recursive functions, see 'man bash'

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

__ocli_ps1 ()
{
    local workspace=`jq --arg pwd $PWD '.[] | objects | select(has("path")) | select(.path != null) | select(.path | inside($pwd)).last_used' ~/.config/odev/projects.json --raw-output`
    if [[ ! -z ${workspace// } ]]
    then
        printf -- "\e[0mworkspace \e[0;33m"
        printf -- $workspace
    fi
    return 0
}
__git_ps1 ()
{
    if [[ `git rev-parse --is-inside-work-tree` == 'true' ]]
    then
        local repo_path=`git rev-parse --show-toplevel | xargs realpath -s --relative-base=$HOME`
        local branch_name=`git rev-parse --abbrev-ref HEAD`
        printf -- "\e[0mrepo \e[0;33m"
        printf -- ${repo_path/./\~}
        printf -- "\n"
        printf -- "\e[0mbranch \e[0;33m"
        printf -- $branch_name
    fi
}


# ---------------------------------------------------------

export BROWSER="firefox-developer-edition"
export EDITOR="nvim"
export LC_COLLATE="C"
export LS_COLORS=$LS_COLORS:'ow=1;34:'
export PS1='\n\[\e[0;32m\]$(__ocli_ps1)\n$(__git_ps1)\n\[\033[0m\]\w \$ '
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export TZ='Europe/Brussels'

shopt -s autocd




clear
eval $(keychain --eval --quiet github_odoo)
clear

# Completions -------------------------------------------
eval "$(thefuck --alias)"
source ~/.bash_aliases
source ~/.fzf.bash
source /usr/share/bash-completion/completions/git
source $HOME/.bash_completions/ocli.sh
# -------------------------------------------------------

starter
