#!/usr/bin/env zsh

setopt auto_cd
setopt auto_pushd
setopt complete_in_word
setopt extended_glob
setopt prompt_subst

alias la='ls -aFl'
alias ll='ls -Fl'

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

autoload -U colors && colors
autoload -U compinit && compinit -U

# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
function zle-keymap-select zle-line-init {
    case "$KEYMAP" in
        vicmd) ZLE_VICMD=1;;
        *)     ZLE_VICMD=0;;
    esac

    zle reset-prompt
}

function zle-line-finish {
    ZLE_VICMD=0
    zle reset-prompt
}

zle -N zle-keymap-select
zle -N zle-line-init

{
    # The variables are wrapped in %{%}. This should be the case for every
    # variable that does not contain space.
    for COLOR in RED GREEN YELLOW BLUE WHITE BLACK; do
        eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
        eval PR_BG_$COLOR='%{$bg_[${(L)COLOR}]%}'
        eval PR_BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
    done

    PROMPT='$PR_BOLD_WHITE${${${ZLE_VICMD-0}/1/⌘}/0/%0(?. .$PR_RED⚠$PR_BOLD_WHITE)}%~%# %{$reset_color%}'
    RPROMPT='$PR_BG_BLACK$PR_WHITE%!%{$reset_color%}'
}

function source-if-exists {
    [[ -s $1 ]] && source $1
}

source-if-exists $HOME/.rvm/scripts/rvm
source-if-exists $HOME/.jachymko/`uname`/zshrc
