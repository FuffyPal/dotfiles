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

# Alias
alias ls="ls --color=auto"
alias l="ls --color=auto"
alias ll="ls -lh --color=auto"
alias la="ls -lha --color=auto"
alias grep="grep --color=auto"
alias helix="/bin/hx"
alias hx="/bin/hx"

source ./.alias

# Paths
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

