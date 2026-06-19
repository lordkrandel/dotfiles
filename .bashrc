[[ $- != *i* ]] && return

command_not_found_handle() {
    # Check if the command exists in the current directory
    if [ -f "./$1" ]; then
        # If it exists in the current directory, execute it
        ./$1 "${@:2}"
    else
        echo "bash: $1: command not found"
        return 127
    fi
}

# ENV --------------------------------------------------------------
export BROWSER=librewolf
export EDITOR=nvim
export LC_COLLATE="C"
export LS_COLORS=$LS_COLORS:'ow=1;34:'
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export TZ='Europe/Brussels'

# SHELL RELATED ---------------------------------------------------
shopt -s autocd
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# COMPLETIONS -----------------------------------------------------
source /usr/share/bash-completion/completions/git
source $HOME/.fzf/shell/completion.bash
source $HOME/.fzf/shell/key-bindings.bash

# FUCK YOU
export _TYPER_STANDARD_TRACEBACK=1

# NVIM PIPE -------------------------------------------------------
export NVIM_PIPE=~/.cache/nvim/server.pipe

# PYENV
export PYENV_ROOT="$HOME/.local/share/pyenv"


if [[ $(whoami) != "root" ]]; then

    # FOLDERS ---------------------------------------------------------
    export PROJ=$HOME/projects
    export NEW=$HOME/new
    export WORK=$HOME/work
    export XDG_CONFIG_DIR=$HOME/.config
    export CONFIG=$HOME/.config

    # APPS ------------------------------------------------------------
    export NOTES=$HOME/notes.md

    # USER COMPLETIONS ------------------------------------------------
    source ~/.bash_aliases
    source ~/.fzf.bash
    source ~/.bash_completions/ocli.sh

    # USER INTERACTION ------------------------------------------------
    source $PROJ/shellrc/shellrc.sh
fi
