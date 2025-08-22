eval "$(/usr/local/bin/brew shellenv)"

export BUN_INSTALL="$HOME/.bun"
export PLAN9=~/psrc/plan9

export path=(
  ~/bin
  ~/.opencode/bin
  ~/.codeium/windsurf/bin
  $BUN_INSTALL/bin
  ~/.local/bin
  $path
  ~/.cargo/bin
  ~/Libary/Python/3.9/bin
  $PLAN9/bin
)

export LESS="-Ri"
export GIT_PAGER='less -F'

export OPENSSL_ROOT_DIR=/opt/homebrew/opt/openssl@3
export AIDER_MODEL=gemini
