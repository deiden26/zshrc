# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Powerlevel10k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# zsh Specific Settings
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Path to oh-my-zsh installation.
export ZSH="/Users/$USER/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
  bundler
  git
  httpie
  npm
  thefuck
  vagrant
  vi-mode
  virtualenv
  # Custom plugins
  autoswitch_virtualenv
  autoupdate
  zsh-autosuggestions
  zsh-nvm
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

# Partial matching git checkout
checkout() {
  branch=$(git branch | grep "$@" -F)
  if [[ $branch == *$'\n'* ]]; then
    printf "\e[31mMultiple branches match \"$@\"\e[0m\n" 1>&2
    printf "$branch\n"
    return 1
  fi
  if [[ $branch == '' ]]; then
    printf "\e[31mNo branches match \"$@\"\e[0m\n" 1>&2
    return 1
  fi
  branch=$(echo $branch | sed 's/^\*//g' | xargs)
  git checkout "$branch"
}
