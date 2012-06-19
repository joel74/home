# ~/.jachymko/tmux

This directory contains the tmux configuration and related scripts.

## Prerequisities
* ~/.jachymko must be linked, as the config files contain hardcoded <code>~/.jachymko/tmux</code> paths

## tmux.conf
* symlinked to ~/.tmux.conf
* 'slave' config, meant to be used in SSH sessions, nested in a local tmux instance
* uses Ctrl-A prefix

## tmux.master
* 'master' config, used by the locally running tmux instance. 
* uses Ctrl-Alt-A prefix

## tmux.shared
* common configuration sourced by both of the aforementioned files
