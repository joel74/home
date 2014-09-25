#!/usr/bin/env zsh

if [[ (-n "$SSH_TTY") || "$(uname -a)" == "Darwin" ]]
then
    export LC_ALL=en_US.UTF-8
fi

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
