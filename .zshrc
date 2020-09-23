# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Powerlevel10k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Oh-my-zsh, Plugins and Theme
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
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
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

# Add some homebrew packages to the path
export PATH="/usr/local/sbin:$PATH"

# Add poetry to the path
export PATH="$HOME/.poetry/bin:$PATH"

# Add pyenv to the path
export PATH="$HOME/.pyenv/bin:$PATH"

# Activate rbenv
if [ -x "$(command -v rbenv)" ]; then
  eval "$(rbenv init -)"
fi

# Activate pyenv
if [ -x "$(command -v pyenv)" ]; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Functions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Run silently in the background
br () { "$@" 1>/dev/null 2>/dev/null & }

# Trigger system message on Macs
notify() {
    local message=${1:-"Done"}
    osascript -e "display notification \"${message}\" with title \"iTerm\" sound name \"Glass\""
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
