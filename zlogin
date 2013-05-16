#!/usr/bin/env zsh

multiplexer
motd

 # Load RVM into a shell session *as a function*
if [ -s "${HOME}/.rvm/scripts/rvm" ]; then
    source "${HOME}/.rvm/scripts/rvm"
fi
