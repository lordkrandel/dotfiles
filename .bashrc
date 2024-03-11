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
        printf -- "\e[0mworkspace=\e[0;33m"
        printf -- $workspace
        printf -- ", "
    fi
    return 0
}
__git_ps1 ()
{
    if [[ `git rev-parse --is-inside-work-tree` == 'true' ]]
    then
        local repo_path=`git rev-parse --show-toplevel | xargs realpath -s --relative-base=$HOME`
        local branch_name=`git rev-parse --abbrev-ref HEAD`
        printf -- "\e[0mrepo=\e[0;33m"
        printf -- ${repo_path/./\~}
        printf -- ", "
        printf -- "\e[0mbranch=\e[0;33m"
        printf -- $branch_name
    fi
}

PS1='\n[\[\e[0;32m\]$(__ocli_ps1)$(__git_ps1)]\n\[\033[0m\]\w \$ '

# ---------------------------------------------------------

export EDITOR="nvim"
export LC_COLLATE="C"
LS_COLORS=$LS_COLORS:'ow=1;34:'
export LS_COLORS
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
shopt -s autocd
TZ='Europe/Brussels'
export TZ


clear
eval $(keychain --eval --quiet github_odoo)

clear

# Completions -------------------------------------------
[[ -f ~/.bash_aliases   ]] && . ~/.bash_aliases
eval "$(thefuck --alias)"
[[ -f ~/.fzf.bash       ]] && source ~/.fzf.bash
[[ -f ~/bin/fzf-tab-completion/bash/fzf-tab-completion.bash ]] && source ~/bin/fzf-tab-completion/bash/fzf-tab-completion.bash
source /usr/share/fzf-tab-completion/bash/fzf-bash-completion.sh
bind -x '"\t": fzf_bash_completion'
. $HOME/.bash_completions/ocli.sh
# -------------------------------------------------------

echo ''
starter
echo ''
