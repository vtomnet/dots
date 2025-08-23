alias lc='eza'
alias vi=nvim
alias chrome='open -a "Google Chrome"'
#alias ed=/opt/homebrew/opt/ed/libexec/gnubin/ed
setopt interactive_comments
setopt shwordsplit
set +H
set +o histexpand

self=mini # or mbp, or vps

function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  if test -n "$timer"; then
    timer_show=$((SECONDS - timer))
    if test $timer_show -gt 10; then
      export RPROMPT="${timer_show}s"
    else
      unset RPROMPT
    fi
    unset timer
  fi
}

readonly prompt
#PS1=": %m %* %2~ ; "
#PS1="%m %2 ~ %% "
PS1="$self %2~ %% "

export HISTSIZE=1000000
export SAVEHIST=1000000

export EDITOR=vi

key() {
  for k; do
    grep -F "$k" ~/keys.txt | while read -r match; do
      eval export "$match"
      echo "Exported ${match%%=*}" >&2
    done
  done
}

key GEMINI_API_KEY 2>/dev/null

eval $(fnm env)

#fpath+=("$(brew --prefix)/share/zsh/site-functions")
#autoload -U promptinit; promptinit
#prompt pure
#source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
#source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#eval "$(starship init zsh)"

#man() { MANWIDTH=$(tput cols) command man "$@" | col -b | bat -p -l man --tabs 0; }

# bun completions
[ -s "/Users/tm/.bun/_bun" ] && source "/Users/tm/.bun/_bun"

bindkey -e
bindkey "^[[3~" delete-char # zed needs this for some reason

#_term_bg() { printf '\033]11;%s\007'; }
alias _term_bg="printf '\\033]11;%s\\007'"

set_term_bg() {
  case $self in
    mini) _term_bg '#E8F5E9' ;;
    vps) _term_bg '#E6F0FF' ;;
    mbp) _term_bg '#FFFFFF' ;;
  esac
}

ssh() {
  command ssh "$@"
  set_term_bg
}

set_term_bg

claude() {
  local PORT=4141
  if ! lsof -i tcp:$PORT >/dev/null 2>&1; then
    echo "Server is not running on port $PORT; start it with \`bunx copilot-api@latest start --claude-code\`" >&2
    return 1
  fi
  ANTHROPIC_BASE_URL=http://localhost:$PORT \
  ANTHROPIC_AUTH_TOKEN=dummy \
  ANTHROPIC_MODEL=claude-sonnet-4 \
  ANTHROPIC_SMALL_FAST_MODEL=gpt-5-mini \
  tmux new "claude --dangerously-skip-permissions $*"
}
