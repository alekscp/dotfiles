_inside_iterm() {
  [ "$TERM_PROGRAM" = "iTerm.app" ]
}

_not_inside_tmux() {
  [[ -z "$TMUX" ]]
}

# Spin in Tmux if we are in iTerm and not already inside a Tmux session
ensure_tmux_is_running() {
  if _not_inside_tmux && _inside_iterm; then
    tat
  fi
}
