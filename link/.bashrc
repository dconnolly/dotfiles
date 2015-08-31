# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;33m➜\033[0m  $@"; }

function isOSX() {
  if [[ "$OSTYPE" =~ ^darwin ]]; then
      e_success "OSX."
      IS_OSX=true
      return 0
  else
      e_error "No OSX."
      IS_OSX=false
      return 1
  fi
}

function HomeBrewInstalled() {
  if which brew > /dev/null; then
      e_success "HomeBrew."
      HOMEBREW_INSTALLED=true
      return 0
  else
      e_error "No HomeBrew."
      HOMEBREW_INSTALLED=false
      return 1
  fi
}

# Test if a Homebrew formula is already installed. Assumes HomeBrewInstalled() is true.
function isHomebrewFormulaInstalled() {
  brew list | grep $1 > /dev/null
}

# Source all files in ~/.dotfiles/source/
function src() {
  local file
  if [[ "$1" ]]; then
    source "$HOME/.dotfiles/source/$1.sh"
  else
    for file in ~/.dotfiles/source/*; do
      source "$file"
    done
  fi
}

# Run dotfiles script, then source.
function dotfiles() {
  ~/.dotfiles/bin/dotfiles "$@" && src
}

src
isOSX
HomeBrewInstalled

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Bash Completion. Expects brew-installed bash-completion.
if $HOMEBREW_INSTALLED && [ -f $(brew --prefix)/etc/bash_completion ]; then
    $(brew --prefix)/etc/bash_completion
fi

# Allow fancy colors if we have ncurses-term installed
export TERM=xterm-256color

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


#
# PS1
#

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

if isHomebrewFormulaInstalled git-radar ; then
    export PS1="$PS1\$(git-radar --bash --fetch) "
fi

export PS1


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

export TERM=xterm-256color


# Alias definitions.
#
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if $HOMEBREW_INSTALLED; then
    export HOMEBREW_BUILD_FROM_SOURCE=1
fi


export EDITOR='emacs -nw'
export LANG="en_US.UTF-8"

if $IS_OSX; then
    export JAVA_HOME=$(/usr/libexec/java_home)
fi

## Android SDK
export ANDROID_HOME=/usr/local/opt/android-sdk

# BEGIN PATH MODIFICATION

PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Add binaries into the path
PATH=~/.dotfiles/bin:$PATH

# Chromium depot tools
PATH=~/dev/depot_tools:$PATH

# NPM things
PATH=/usr/local/share/npm/bin:$PATH

# NVM things (assumes Homebrew)
if $HOMEBREW_INSTALLED && isHomebrewFormulaInstalled nvm ; then
    export NVM_DIR=$(brew --prefix)/var/nvm
    source $(brew --prefix nvm)/nvm.sh
fi

# Go things
export GOPATH=$HOME/.go
PATH=$PATH:$GOPATH/bin

# If we have coreutils installed via HomeBrew, use those instead of OSX's.
if $HOMEBREW_INSTALLED && isHomebrewFormulaInstalled coreutils ; then
    PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
    MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
fi

export PATH
export MANPATH

# END PATH MODIFICATION

eval "$(grunt --completion=bash)"

# The next line updates PATH for the Google Cloud SDK.
source ~/dev/google-cloud-sdk/path.bash.inc

# The next line enables bash completion for gcloud.
source ~/dev/google-cloud-sdk/completion.bash.inc
