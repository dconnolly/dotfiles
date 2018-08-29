getRemoteCert(){
  openssl s_client -trace -connect $1 -showcerts | openssl x509 -inform pem -text
}

alias jobs='jobs -l'
alias ls='ls -lahG --color'
alias df='df -h'
alias du='du -h'
alias wget='axel'
alias ack='ag'
alias e='emacs'
alias emasc='emacs'
alias g='git'
alias rsync='rsync --verbose --human-readable --archive --partial --checksum --itemize-changes --progress'
alias letsencrypt='/Users/dconnolly/dev/letsencrypt/letsencrypt/venv/bin/letsencrypt'
alias ack-replace='ack -l $1 | xargs -p sed -i -e "s|$1|$2|g"'
alias openssl-get-remote-cert=getRemoteCert
alias http='bat'
