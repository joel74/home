#!/usr/bin/env zsh

typeset -grx JACHYMKO=`echo ~/.jachymko(:A)`

typeset -gxU PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
typeset -gx  PAGER=less
typeset -gx  VISUAL=vim
typeset -gx  EDITOR=$VISUAL

# autoload all functions in .jachymko/zsh
fpath=($JACHYMKO/zsh $fpath)
autoload $JACHYMKO/zsh/*(:t)
