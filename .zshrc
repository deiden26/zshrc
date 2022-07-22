# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Aliases
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
alias zshconfig='vim ~/.zshrc'
alias trim='git branch --merged | grep -v "\*" | grep -v "master" | xargs -n 1 git branch -d'
alias diffb='git diff $(git merge-base --fork-point master)'
alias v='nvim'

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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Powerlevel10k
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OMZP::bundler
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
BUNDLED_COMMANDS=(tapioca)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# lukechilds/zsh-nvm
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Show autocomplete suggestions in the shell
export NVM_COMPLETION=true
# Automatically use Node version in .nvmrc files
export NVM_AUTO_USE=true

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Install zinit
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load zinit
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Plugins
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Oh-My-Zsh Plugins
zinit snippet OMZP::bundler
zinit snippet OMZP::git
# zinit ice as="completion"
# zinit snippet OMZP::httpie
zinit snippet OMZP::npm
zinit snippet OMZP::thefuck
zinit snippet OMZP::vagrant
zinit snippet OMZP::vi-mode
zinit snippet OMZP::virtualenv
zinit snippet OMZP::colored-man-pages

# Oh-My-Zsh Libraries
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::completion.zsh


# Other Plugins
zinit light MichaelAquilina/zsh-autoswitch-virtualenv
zinit light lukechilds/zsh-nvm
zinit light hlissner/zsh-autopair
zinit light wfxr/forgit

# Theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Completions, Syntax Highlighting, & Suggestions
zinit ice wait lucid atinit="ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit load zdharma-continuum/fast-syntax-highlighting
zinit ice wait lucid blockf
zinit load zsh-users/zsh-completions
zinit ice wait lucid atload="!_zsh_autosuggest_start"
zinit load zsh-users/zsh-autosuggestions

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Misc
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Colors for ls command
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export LS_COLORS='di=1;34:ln=1;35:so=1;31:pi=1;33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43hcs'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

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

# Configure fzf
if type rg &> /dev/null; then
  # Use ripgrep if available
  export FZF_DEFAULT_COMMAND='rg --files'
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Source machine-specific settings
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ -f ~/.zshrc-alto ]; then
  source ~/.zshrc-alto
fi
