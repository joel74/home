setopt autocd
setopt completeinword
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
    VIMODE="${KEYMAP/(main|viins)/}"
    zle reset-prompt
}

function zle-line-finish {
    VIMODE=""
    zle reset-prompt
}

zle -N zle-keymap-select
zle -N zle-line-init


# autoload all functions in .jachymko/zsh
for fn in $JACHYMKO/zsh/*; do
    autoload $fn:t
done

{
    # The variables are wrapped in %{%}. This should be the case for every
    # variable that does not contain space.
    for COLOR in RED GREEN YELLOW BLUE WHITE BLACK; do
        eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
        eval PR_BG_$COLOR='%{$bg_[${(L)COLOR}]%}'
        eval PR_BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
    done

    # Finally, let's set the prompt
    PROMPT='$PR_BOLD_WHITE%m:%~%# %{$reset_color%}'
    RPROMPT='$PR_BG_BLACK$PR_WHITE%!%{$reset_color%}'
}
