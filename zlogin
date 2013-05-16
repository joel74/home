multiplexer() {
    local TMUX_DIR MASTER_CONF tmux master_tmux reattach

    TMUX_DIR="${HOME}/.jachymko/tmux"
    MASTER_CONF="${TMUX_DIR}/tmux.conf.master"

    tmux=`which tmux`
    master_tmux="${tmux} -L master -f ${MASTER_CONF}"
    reattach=`which reattach-to-user-namespace`

    if [ -x "${reattach}" ]; then
        reattach="${reattach} -l "
    fi

    if [ -x "${tmux}" ]; then # tmux installed, yay!

        if [ -n "${SSH_CLIENT}" ]; then

            # ssh: attach to an existing tmux session
            # or start a new one
            exec ${tmux} new-session -As default
        fi

        if [ -z "${TMUX}" ]; then

            # local terminal and not inside tmux
            # start a session and create default windows
            if ! ${=master_tmux} has-session -t master; then

                ${=master_tmux} new-session -dn ${HOST} -s master \;\
                                new-window  -dn daemonik 'ssh jachymko.net'
            fi

            # start a client
            exec ${=master_tmux} attach-session -t master
        fi

        if [ -z "${MASTER_TMUX}" ]; then
            # unset ${TMUX} to enable a nested session
            MASTER_TMUX=${TMUX}; unset TMUX
            # start/attach the local session
            exec ${tmux} start-server                                        \;\
                         set-environment -g MASTER_TMUX ${MASTER_TMUX}       \;\
                         set-option -g default-command "${reattach}${SHELL}" \;\
                         new-session -As default                             \;\
                         split-window -dh
        fi
    fi
}

multiplexer
motd

 # Load RVM into a shell session *as a function*
if [ -s "${HOME}/.rvm/scripts/rvm" ]; then
    source "${HOME}/.rvm/scripts/rvm"
fi
