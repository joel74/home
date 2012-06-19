typeset -grx JACHYMKO=`echo ~/.jachymko(:A)`

typeset -gxU PATH=$JACHYMKO:$PATH
typeset -gx  PAGER=less
typeset -gx  VISUAL=vim
typeset -gx  EDITOR=$VISUAL

fpath=($JACHYMKO/zsh $fpath)
