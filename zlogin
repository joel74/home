#!/usr/bin/env zsh

if [[ -x "${HOME}/.julie/tmux/multiplexer" ]]
then
    ${HOME}/.julie/tmux/multiplexer
fi

motd

if [[ -s "$HOME/.rvm/scripts/rvm" ]]
then
    # Load RVM into a shell session *as a function*
    source "$HOME/.rvm/scripts/rvm"
fi
