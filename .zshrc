export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export MANPAGER="vim -M +MANPAGER -"
export EDITOR="vim"
export FZF_DEFAULT_COMMAND="find * -type f"
export COMPLETION_FILE="$XDG_CONFIG_HOME/zsh/completion.zsh"
export PRIVATE_EXPORTS_FILE="$XDG_CONFIG_HOME/zsh/private/exports.zsh"

alias :q="exit"
alias grep='grep --color=auto'
alias rm='rm -I'
alias cp='cp -i'
alias mv='mv -i'
# No longer using -G flag because ls is linked to lsd. they interpret it differently.
alias ll="ls -laFh"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Prompt: username@hostname(short) cwd(last part) %"
PS1="%n@%m %1~ %# "

if [[ -f "$COMPLETION_FILE" ]]; then
  source $COMPLETION_FILE
fi

if [[ -f "$PRIVATE_EXPORTS_FILE" ]]; then
  source $PRIVATE_EXPORTS_FILE
fi

if command -v zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
fi

# =========================
# Zsh Bindings
# =========================

bindkey '\e[1;3D' backward-word     # Alt + Left
bindkey '\e[1;3C' forward-word      # Alt + Right
bindkey '^[^?' backward-kill-word   # Alt + Backspace
bindkey '^[[3;3~' kill-word         # Alt + Delete
bindkey '\e[H' beginning-of-line    # Home
bindkey '\e[F' end-of-line          # End

# =========================
# Zsh History Configuration
# =========================

# History file
HISTFILE="$XDG_CACHE_HOME/.zsh_history"

# Share history across all zsh sessions
setopt SHARE_HISTORY

# Append to the history file instead of overwriting it
setopt APPEND_HISTORY

# Hide commands if they start with a space character
setopt HIST_IGNORE_SPACE

# Write history after each command (not just on shell exit)
setopt INC_APPEND_HISTORY

# Save each command as it's typed, not just after it's executed
# setopt INC_APPEND_HISTORY_TIME

# Record timestamp for each command
setopt EXTENDED_HISTORY

# Expand history commands with ! before execution
setopt HIST_VERIFY

# Number of commands to keep in memory during session
HISTSIZE=1000

# Number of commands to save to HISTFILE
SAVEHIST=1000

