function fzf-rebase() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

function ghq-cd-fzf {
  repo=`ghq list | fzf`
  if [ -n "$repo" ]; then
    cd $HOME/.ghq/src/$repo
  fi
}
