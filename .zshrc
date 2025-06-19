# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Aliases
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
alias v='nvim'
alias zshconfig='nvim ~/.zshrc'
alias diffb='git diff $(git merge-base --fork-point master)'

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

trim() {
  test_run=0
  base_branch='main'

  while getopts "tb:" opt; do
    case "$opt" in
      t)
        test_run=1
        ;;
      b)
        base_branch=$OPTARG
        ;;
    esac
  done

  initial_branch=$(git rev-parse --abbrev-ref HEAD)

  git checkout -q $base_branch &> /dev/null

  exit_status=$?
  if [ ${exit_status} -ne 0 ]; then
    red='\033[0;31m'
    no_color='\033[0m'
    echo "${red}Error: base branch \"${base_branch}\" does not exist${no_color}"
    return "${exit_status}"
  fi

  if [[ ! $test_run ]]; then
    trim_command=(git branch -D)
  else
    bold_cyan='\033[1;36m'
    cyan='\033[0;36m'
    no_color='\033[0m'

    message="${bold_cyan}Test Run:${no_color} "
    message+="${cyan}a live run will delete the following branches\n${no_color}"
    echo -e $message

    trim_command=(echo)
  fi

  setopt LOCAL_OPTIONS NO_MONITOR
  branches=$(git for-each-ref refs/heads/ "--format=%(refname:short)")
  while IFS= read -r branch; do
    _maybe_trim_branch $base_branch $branch $trim_command &
  done <<< "$branches"
  wait

  git checkout -q $initial_branch
}

_maybe_trim_branch() {
  base_branch=$1
  branch=$2
  trim_command=$3

  merge_base=$(git merge-base $base_branch $branch)
  rev_parse=$(git rev-parse "$branch^{tree}")
  commit_tree=$(git commit-tree $rev_parse -p $merge_base -m _)
  cherry=$(git cherry $base_branch $commit_tree)
  if [[ $cherry == "-"* ]]; then
    "${trim_command[@]}" $branch
  fi
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
BUNDLED_COMMANDS=(srb tapioca)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# lukechilds/zsh-nvm
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
zinit snippet OMZP::vi-mode
zinit snippet OMZP::colored-man-pages

# Oh-My-Zsh Libraries
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::completion.zsh


# Other Plugins
zinit light-mode wait lucid for \
  lukechilds/zsh-nvm \
  hlissner/zsh-autopair

# Theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Completions, Syntax Highlighting, & Suggestions
zinit ice wait lucid atinit="ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice wait lucid blockf
zinit light zsh-users/zsh-completions
zinit ice wait lucid atload="!_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit light mroth/evalcache

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
  _evalcache rbenv init --no-rehash -
fi

# Activate pyenv
if [ -x "$(command -v pyenv)" ]; then
  _evalcache pyenv init - zsh
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
