#!/usr/bin/env zsh

typeset -gx JACHYMKO=`echo ~/.jachymko(:a)`

typeset -gxU PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
typeset -gx  PAGER=less
typeset -gx  VISUAL=vim
typeset -gx  EDITOR=$VISUAL

if [[ -d /usr/local/share/npm/bin ]]; then
    typeset -gxU PATH=/usr/local/share/npm/bin:$PATH
fi

# autoload all functions in .jachymko/zsh
fpath=($JACHYMKO/zsh $fpath)
autoload $JACHYMKO/zsh/*(:t)
