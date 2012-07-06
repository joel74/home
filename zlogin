#!/usr/bin/env zsh

if [[ -z "$TMUX" ]] then
    # use master tmux config on local terminal
    if [[ -z "$SSH_CLIENT" ]] then
        tmuxargs="-f $HOME/.jachymko/tmux/tmux.conf.master"
    fi

    tmux ${=tmuxargs} start-server
    tmux attach-session
fi

motd

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
