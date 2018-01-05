compdef g=git
function g {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status --short --branch
  fi
}

# Have pager clean output after exit
# https://superuser.com/questions/366930/how-do-i-get-the-git-pager-to-clean-up-screen-output-after-exit
export LESS=R
