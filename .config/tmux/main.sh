#!/bin/bash

. ~/.bash_completions/ocli.sh
. ~/work/scripts/shellrc/shellrc.sh

clear
macchina
eval $(keychain --eval --quiet github_odoo)
pushd &>/dev/null
ocli status
