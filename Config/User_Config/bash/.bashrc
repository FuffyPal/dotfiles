# History
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# User
PS1="\[\e[38;2;255;171;185m\]\u@\h \[\e[38;2;180;200;255m\]\w\[\e[0m\]\$ "

case "$TERM" in
    xterm*|vte*)
        PS1='\[\e]0;\u@\h: \w\a\]'$PS1
        ;;
esac

# Enable Bash completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# Alias
alias ls="ls --color=auto"
alias l="ls --color=auto"
alias ll="ls -lh --color=auto"
alias la="ls -lha --color=auto"
alias grep="grep --color=auto"
alias helix="/bin/hx"
alias hx="/bin/hx"

source $HOME/.alias

# Paths
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/fluffypal/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/fluffypal/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/fluffypal/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/fluffypal/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

