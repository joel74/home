#!/usr/bin/env zsh

# use master tmux config on local terminal
if [[ -z "$SSH_CLIENT" ]] then
    tmuxconf=${tmuxconf-~/.jachymko/tmux/tmux.conf.master}
fi

tmux-attach-or-new $tmuxconf || motd
