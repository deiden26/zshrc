# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# zsh Specific Settings
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Path to oh-my-zsh installation.
export ZSH="/Users/$USER/.oh-my-zsh"

ZSH_THEME="agnoster"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
  git
  httpie
  npm
  vagrant
  vi-mode
  thefuck
  # Custom plugins
  zsh-autosuggestions
  zsh-nvm
  autoupdate
)

source $ZSH/oh-my-zsh.sh

# Enable ompletiton
test -f ~/.zsh-completion.bash && . $_

# Activate syntax highlighting. Follow these instructions for a new machine
# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh
source /Users/$USER/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Aliases
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
alias zshconfig='vim ~/.zshrc'
alias trim='git branch --merged | grep -v "\*" | grep -v "master" | xargs -n 1 git branch -d'
alias diffb='git diff $(git merge-base --fork-point master)'
alias v='nvim'
# TODO remove this once you start using v so you can use vim on purpose
alias vim='echo "Use NeoVim, you butt"; v'

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Source machine-specific settings
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[ -f ~/.zshrc-alto ] && source ~/.zshrc-alto

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Misc
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Colors for ls command
export LSCOLORS=ExFxBxDxCxegedabagacad

# Preferred editor
export EDITOR='nvim'

# Activate rbenv
if [ -x "$(command -v rbenv)" ]; then
  eval "$(rbenv init -)"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Functions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Run silently in the background
br () { "$@" 1>/dev/null 2>/dev/null & }

# Trigger system message
notify() {
    local message=${1:-"Done"}
    echo @notify:$message
}
