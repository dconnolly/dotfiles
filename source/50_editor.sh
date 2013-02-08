# Editing

export EDITOR='emacs -nw'
export LESSEDIT='emacs -nw'
export VISUAL="$EDITOR"

alias q='emacs'

alias q.='q .'

function qs() {
  pwd | perl -ne"s#^$(echo ~/.dotfiles)## && exit 1" && cd ~/.dotfiles
  q ~/.dotfiles
}
