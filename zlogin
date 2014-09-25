#!/usr/bin/env zsh

# Use en_US.UTF-8 on Darwin or when over SSH.
# FreeBSD console sadly doesn't support Unicode yet.
if [[ (-n "$SSH_TTY") || ("$(uname -a)" == "Darwin") ]]
then
    export LANG=en_US.UTF-8
fi

# Launch the multiplexer, if available.
if [[ -x "${HOME}/.julie/tmux/multiplexer" ]]
then
    ${HOME}/.julie/tmux/multiplexer
fi

# If it quits, or this shell is alread running inside,
# show a nice message.
motd

# Load RVM into a shell session as a function, if available.
if [[ -s "$HOME/.rvm/scripts/rvm" ]]
then
    source "$HOME/.rvm/scripts/rvm"
fi
