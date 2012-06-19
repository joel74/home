* tmux config for local and remote sessions.
* [https://github.com/jachymko/home/blob/master/zlogin] determines which config will be used.
* assumes utf-8, 256-color capable term

### Prerequisities
* zsh must be installed
* <code>~/.jachymko</code> must be linked, as the config files contain hardcoded <code>~/.jachymko/tmux</code> paths.
* on OS X, osascript is used to query iTunes

### tmux.conf
* symlinked to <code>~/.tmux.conf</code>
* 'slave' config, meant to be used in SSH sessions, nested in a local tmux instance
* uses <kbd>Ctrl</kbd>&nbsp;<kbd>A</kbd> prefix
* displays hostname in statusbar

### tmux.conf.master
* 'master' config, used by the locally running tmux instance.
* uses <kbd>Ctrl</kbd>&nbsp;<kbd>Alt</kbd>&nbsp;<kbd>A</kbd> prefix
* displays current date time, and output of the <code>tmux.master-statusright</code> script in statusbar

### tmux.conf.shared
* common configuration sourced by both of the configs

### master-statusright
* output of this script is displayed on the master tmux status bar
* shows the track currently being played in iTunes

