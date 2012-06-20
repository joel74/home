#!/usr/bin/env zsh

# use master tmux config on local terminal
if [[ -z "$SSH_CLIENT" ]] then
    tmuxconf=${tmuxconf-~/.jachymko/tmux/tmux.conf.master}
fi

tmuxcmd='
    renamew shell; split -h;
    neww -d -n vim vim'

tmux-attach-or-new -f $tmuxconf ${=tmuxcmd} || motd
