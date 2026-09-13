# --------------------------------
#
#         .bash_aliases
#
# --------------------------------


cd() {
    builtin cd "$@" || return
    if [[ -f .description ]]; then
        ~/projects/lld/lld
    fi
}


timer() {
    ROOSTER=~/music/rooster.wav
    KEEPALIVE=5000
    TITLE=Timer

    if [ -z "$1" ]; then
        atq | while read -r id d t q u r; do
            DESC=$(at -c "$id" | grep $TITLE | grep -o "'.*'" | tr -d "'")
            echo "# $id: $q $t $u $DESC"
        done
        return 0
    fi

    echo "DISPLAY=:0 notify-send \"$TITLE \$(date +%H:%M)\" '$2' -t $KEEPALIVE && mpv $ROOSTER" | at "$1"
}


qrencode () {
    TEMPFILE=$(mktemp)
    trap "'rm -f $TEMPFILE'" 0 2 3 15
    qrtool encode "$*" > $TEMPFILE
    nohup gimp -sf $TEMPFILE &>/dev/null &
}

activate () {
    pushd .venv$1/bin &>/dev/null
    source activate
    popd &>/dev/null
}

lsub () {
    source $PROJ/lsub/.venv/bin/activate && $PROJ/lsub/lsub.py "$@"
}
exp() {

    local FZF="fzf --ansi --border --height=40% --layout=reverse"
    local REPO_LIST_FILE="$HOME/work/odoo_repos"
    local REPO_NAME=$( \
        cat "$REPO_LIST_FILE" \
        | sed "s/odoo\///g" \
        | $FZF --header="$REPO_LIST_FILE" --prompt="repo > " \
    )
    if [ -z "$REPO_NAME" ]; then
        return 1
    fi

    local REPO_DIR="$HOME/work/$REPO_NAME"
    (
        cd "$REPO_DIR" >/dev/null
        local BRANCH_REF=$( \
            git branch --all --no-color \
            | grep -v HEAD \
            | sed "s/^[ *]*//g" \
            | sed "s/remotes\/origin\///g" \
            | sed "s/remotes\/dev\///g" \
            | grep -Ev "^(tmp\.|staging\.)" \
            | $FZF --tac --header="$REPO_NAME" --prompt="branch > " \
        )
        if [ -z "$BRANCH_REF" ]; then
            return 1
        fi
        local FILE_PATH=$( \
            git ls-tree -r --name-only "$BRANCH_REF" \
            | $FZF --scheme=path --header="$BRANCH_REF" --prompt="file > "
        )
        if [ -z "$FILE_PATH" ]; then
            return 1
        fi
        echo $BRANCH_REF:$REPO_DIR/$FILE_PATH
        COMM=$(printf "execute('tabnew | Gedit %s:%s/%s')" "$BRANCH_REF" "$REPO_DIR" "$FILE_PATH")
        nvim --server "$NVIM" --remote-expr "$COMM"
    )
}

remake() {
    pushd ~/bin/st &>/dev/null
    make &>/dev/null
    popd &>/dev/null
}

pgconn() {
    psql -U $USER -d $USER  --field-separator=' ' --no-align --pset="footer=off" --tuples-only -c " \
        SELECT \
            pid, \
            application_name \
        FROM \
            pg_stat_activity \
        WHERE \
            state='active' \
            AND client_addr IS NULL \
            OR client_addr = '127.0.0.1' \
            AND application_name NOT LIKE '%psql%' \
        ;"
}

alias ali="$EDITOR ~/.bash_aliases"
alias ask="$PROJ/ask/ask.sh $*"
alias act="activate $*"
alias bat="bat --wrap never $*"
alias blank="clear && clear && reset && reset $*"
alias bundle="$PROJ/go_bundle/bundle $*"
alias ccal="cal -mn 3 $*"
alias cards="$PROJ/cards/cards $*"
alias clip="xclip -sel clipboard $*"
alias dea="deactivate $*"
alias dir="ll $*"
alias ll="ls -al --color=auto $*"
alias lw="$PROJ/scripts/open_with_librewolf.sh $*"
alias dropboxsync="rclone bisync Dropbox: ~/Dropbox --resync --verbose --exclude '/.dropbox' --exclude '/.dropbox.cache'"
alias hw="hardinfo2 $*"
alias monitor="$PROJ/scripts/monitor.sh $*"
alias noswap="rm ~/.local/state/nvim/swap/* $*"
alias note="nvim +':normal! Go' +startinsert $NOTES"
alias notes="tail $* $NOTES"
alias is_repo="$PROJ/scripts/is_repo.py $*"
alias rankmirrors="eos-rankmirrors -t 2"
alias pacclean="sudo pacman -Rns \$(pacman -Qdtq)"
alias pg="pgcli $*"
alias pl="$PROJ/pl/pl $*"
alias py="ipython $*"
alias realias=". ~/.bash_aliases $*"
alias reload=". ~/.bashrc $*"
alias rap="rg --no-heading -C 3 --type=py --type=xml --color=always $*"
alias si="yes S"
alias update-pip="pip install --upgrade pip"
alias nohist="cat /dev/null > ~/.bash_history && history -c && exit"
alias jar="$PROJ/scripts/cookiejar.sh $*"
alias wat="$PROJ/wat/wat.sh $*"
