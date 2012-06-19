typeset -grx JACHYMKO=`echo ~/.jachymko(:A)`

typeset -gxU PATH=$JACHYMKO:$PATH
typeset -gx  PAGER=less
typeset -gx  VISUAL=vim
typeset -gx  EDITOR=$VISUAL

fpath=($JACHYMKO/zsh $fpath)

# autoload all functions in .jachymko/zsh
for fn in $JACHYMKO/zsh/*; do
    autoload $fn:t
done

