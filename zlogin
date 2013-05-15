multiplexer() {
    local MASTER_CONF tmux reattach

    MASTER_CONF="${HOME}/.jachymko/tmux/tmux.conf.master"
    reattach=`which reattach-to-user-namespace`
    tmux=`which tmux`

    if [ -x "${reattach}" ]; then
        reattach="${reattach} -l "
    fi

    if [ -x "${tmux}" ]; then
        if [ -n "${SSH_CLIENT}" ]; then

            # ssh: attach to an existing tmux session
            # or start a new one
            exec ${tmux} new-session -As default

        elif [ -z "${TMUX}" ]; then

            # local terminal and not inside tmux, start/attach the master
            exec ${tmux} -L master -f ${MASTER_CONF} new-session -As master

        elif [ -z "${MASTER_TMUX}" ]; then
            # running in the master tmux,
            # mark it so and start/attach the local session

            MASTER_TMUX=${TMUX}; unset TMUX

            exec ${tmux} start-server \;\
                         set-environment -g MASTER_TMUX ${MASTER_TMUX} \;\
                         new-session -As default \;\
                         set-option -g default-command "${reattach}${SHELL}"

        fi
    fi
}

multiplexer
motd

 # Load RVM into a shell session *as a function*
if [ -s "${HOME}/.rvm/scripts/rvm" ]; then
    source "${HOME}/.rvm/scripts/rvm"
fi
