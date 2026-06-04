#!/usr/bin/bash


sqlite3 "file://$HOME/.librewolf/3d5vwzcw.default-default/cookies.sqlite?immutable=1" -csv \
        "SELECT value FROM moz_cookies WHERE host='$1' AND name='$2' AND originAttributes = ''";
