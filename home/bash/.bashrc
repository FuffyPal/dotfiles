# ─── History ───────────────────────────────────────────────────────────────────
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
HISTTIMEFORMAT="%F %T  "
shopt -s histappend
shopt -s cmdhist

# ─── Prompt ────────────────────────────────────────────────────────────────────
PS1="\[\e[38;2;255;171;185m\]\u@\h \[\e[38;2;180;200;255m\]\w\[\e[0m\]\$ "

case "$TERM" in
    xterm*|vte*)
        PS1='\[\e]0;\u@\h: \w\a\]'$PS1
        ;;
esac

# ─── Bash completion ───────────────────────────────────────────────────────────
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# ─── Aliases ───────────────────────────────────────────────────────────────────
alias ls="ls --color=auto"
alias l="ls --color=auto"
alias ll="ls -lh --color=auto"
alias la="ls -lha --color=auto"
alias grep="grep --color=auto"
alias helix="/bin/hx"
alias hx="/bin/hx"
alias cat="/bin/bat"
alias top="/bin/btop"

alias up="sudo dnf update -y && flatpak update -y"
alias dnfi="sudo dnf install"
alias dnfs="dnf search"
alias dnfr="sudo dnf remove"

alias systemctl-status="systemctl --failed"
alias ports="ss -tulpn"
alias myip="curl -s ifconfig.me"

alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"

alias comfyui="podman run -d \
  --name comfyui \
  -p 8188:8188 \
  -v models:/models \
  --device nvidia.com/gpu=all \
  --security-opt=label=disable \
  --rm \
  registry.gitlab.com/fluffypal/comfyui-docker:latest"
alias comfyui-status="podman logs -f comfyui"
alias comfyui-stop="podman stop comfyui"

# ─── Paths ─────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# ─── Editor ────────────────────────────────────────────────────────────────────
export EDITOR="hx"
export VISUAL="hx"

# ─── XDG ───────────────────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# ─── Rust ──────────────────────────────────────────────────────────────────────
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
