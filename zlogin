#!/usr/bin/env zsh

if [ -x "${HOME}/.jachymko/tmux/multiplexer" ]; then
    "${HOME}/.jachymko/tmux/multiplexer"
fi

motd

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
