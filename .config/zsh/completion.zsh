# =============================================
# Zsh Completion Configuration
# =============================================

# Initialize the completion system
# -U: Don't run compaudit (security check)
# -z: Use zsh (not ksh) completion system
autoload -Uz compinit

# Initialize completion system
compinit

# =============================================
# Completion Behavior
# =============================================

# Enable menu selection when there are multiple matches
# select=2 means menu appears after second tab press
zstyle ':completion:*' menu select=2

# Enable color highlighting of different file types
zstyle ':completion:*' list-colors ''

# Case-insensitive completion
# m:{a-z}={A-Z} - case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Completion strategies (in order of priority):
# _expand:   Expand aliases and variables
# _complete: Basic completion
# _ignored:  Complete even if pattern would be ignored
# _approximate: Try to correct typos
zstyle ':completion:*' completer _expand _complete _ignored _approximate

# Show completion status in the prompt
zstyle ':completion:*' select-prompt '%SCurrent selection at %p%s'

# Set maximum number of errors allowed for approximate completion
# 2 means it will try to correct up to 2 typos in the word
zstyle ':completion:*' max-errors 2

# =============================================
# Performance Optimizations
# =============================================

# Enable completion caching
zstyle ':completion:*' use-cache on

# Set cache directory (create it if it doesn't exist)
[[ -d ~/.zsh/cache ]] || mkdir -p ~/.zsh/cache
zstyle ':completion:*' cache-path ~/.zsh/cache

# =============================================
# Display Formatting
# =============================================

# Enable grouping of completion items
zstyle ':completion:*' group-name ''

# Format for group headers:
# %U - start underline
# %B - start bold
# %d - group description
# %b - end bold
# %u - end underline
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'

# =============================================
# Additional Completion Features
# =============================================

# Group man pages by section (1=commands, 2=syscalls, etc.)
zstyle ':completion:*:manuals' separate-sections true

# Automatically insert section numbers when completing man pages
zstyle ':completion:*:manuals' insert-sections true

# Do not Complete . and .. special directories
zstyle ':completion:*' special-dirs false

# Don't show already selected files in completion for rm command
# This prevents duplicate entries when using tab completion multiple times
zstyle ':completion:*:rm:*' ignore-line yes

# Show all processes for kill/killall
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Load Zsh completion listing module
# Required for menuselect keymap
zmodload zsh/complist

# Shift+Tab - navigate backward in completion menu
bindkey -M menuselect '^[[Z' reverse-menu-complete
# Esc - cancel selection
bindkey -M menuselect '^['  send-break

