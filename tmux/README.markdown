# ~/.jachymko/tmux

This directory contains the tmux configuration and related scripts.

## Prerequisities
* <code>~/.jachymko</code> must be linked, as the config files contain hardcoded <code>~/.jachymko/tmux</code> paths. 

## tmux.conf
* symlinked to ~/.tmux.conf
* 'slave' config, meant to be used in SSH sessions, nested in a local tmux instance
* uses Ctrl-A prefix

## tmux.master
* 'master' config, used by the locally running tmux instance.
* uses Ctrl-Alt-A prefix

## tmux.master-statusright
* output of this script is displayed on the master tmux status bar
* shows the track currently being played in iTunes

## tmux.shared
* common configuration sourced by both of the aforementioned files
