# ─────────────────────────────────────────────
#  History
# ─────────────────────────────────────────────
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# ─────────────────────────────────────────────
#  Prompt
# ─────────────────────────────────────────────
PS1="\[\e[38;2;255;171;185m\]\u@\h \[\e[38;2;180;200;255m\]\w\[\e[0m\]\$ "
case "$TERM" in
    xterm*|vte*)
        PS1='\[\e]0;\u@\h: \w\a\]'"$PS1"
        ;;
esac

# ─────────────────────────────────────────────
#  Bash Completion
# ─────────────────────────────────────────────
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# ─────────────────────────────────────────────
#  Aliases
# ─────────────────────────────────────────────
alias ls="ls --color=auto"
alias l="ls --color=auto"
alias ll="ls -lh --color=auto"
alias la="ls -lha --color=auto"
alias grep="grep --color=auto"

# Editor
alias helix="hx"

# System update (OpenSUSE Tumbleweed)
alias up="sudo zypper dup -y && flatpak update -y"
alias install="sudo zypper install"
alias remove="sudo zypper remove"
alias search="zypper search"

# Tools (fallback-safe)
command -v lolcat &>/dev/null && alias cat="lolcat"
command -v btop   &>/dev/null && alias top="btop"

# ─────────────────────────────────────────────
#  Paths
# ─────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ─────────────────────────────────────────────
#  Editor default
# ─────────────────────────────────────────────
export EDITOR="hx"
export VISUAL="hx"
