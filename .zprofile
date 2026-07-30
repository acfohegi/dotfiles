export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export MANPAGER="vim -M +MANPAGER -"
export EDITOR="vim"
export FZF_DEFAULT_COMMAND="find * -type f"

case "$(uname -s)" in
  Darwin)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ;;
  Linux)
    export PATH="$HOME/.local/bin:$PATH"
    ;;
esac

