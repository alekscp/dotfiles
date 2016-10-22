export DISABLE_AUTO_TITLE="true"

alias tls="tmux list-sessions"

_not_inside_tmux() {
  [[ -z "$TMUX" ]]
}

ensure_tmux_is_running() {
  if _not_inside_tmux; then
    tat
  fi
}
