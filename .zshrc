export PAGER=less
export VISUAL=vim
export EDITOR=$VISUAL

alias ls='ls -aFl'

if [[ -z "$TMUX" ]]; then
	tmux attach || tmux
fi
