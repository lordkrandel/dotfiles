#!/usr/bin/bash

packagever() {
    PKG_URL="https://archlinux.org/packages/$1/$2/$3/json/"
    PKG_DATA=$(curl -s $PKG_URL)
    PKG_FILENAME=$(echo $PKG_DATA | jq -r .filename)
    export PKG_REMOTE=$(echo $PKG_FILENAME | sed "s/discord-\(.*\)-$2.*/\1/g")
    export PKG_INSTALLED=$(pacman -Qi discord | grep Version | sed "s/Version.*: \(.*\)/\1/g")
    export PKG_URL="https://mirror.pseudoform.org/$1/os/$2/$PKG_FILENAME"
}

packagever extra x86_64 discord
echo remote=$PKG_REMOTE installed=$PKG_INSTALLED
if [ "$PKG_REMOTE" != "$PKG_INSTALLED" ]; then
    yes S | pkexec pacman -U "$PKG_URL"
fi

exec discord
