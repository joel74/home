#!/usr/bin/env zsh

typeset -grx JACHYMKO=`echo ~/.jachymko(:A)`

typeset -gxU PATH=$JACHYMKO/bin:$PATH
typeset -gx  PAGER=less
typeset -gx  VISUAL=vim
typeset -gx  EDITOR=$VISUAL

# autoload all functions in .jachymko/zsh
fpath=($JACHYMKO/zsh $fpath)
autoload $JACHYMKO/zsh/*(:t)

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
