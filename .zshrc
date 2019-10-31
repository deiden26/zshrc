# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# zsh Specific Settings
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Path to oh-my-zsh installation.
export ZSH="/Users/deiden/.oh-my-zsh"

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

# Activate syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Aliases
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
alias zshconfig="vim ~/.zshrc"
alias cv='cd /Users/deiden/Documents/Coding/MyVR/VacationRentals'
alias trim='git branch --merged | grep -v "\*" | grep -v "develop" | xargs -n 1 git branch -d'
alias diffb='git diff $(git merge-base --fork-point develop)'

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Misc
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Colors for ls command
export LSCOLORS=ExFxBxDxCxegedabagacad

# Preferred editor
export EDITOR='vim'

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Functions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Run silently in the background
br () { "$@" 1>/dev/null 2>/dev/null & }

# Upload NodeBB plugin
pubnodebb() {
    git push origin master
    npm publish
    curl -X PUT https://packages.nodebb.org/api/v1/plugins/${PWD##*/}
    echo
}

# Trigger system message
notify() {
    local message=${1:-"Done"}
    echo @notify:$message
}

# Check domain certs
function domaintool () {
    echo ""
    echo "###############################################"
    echo "#        Enter domain name to check.          #"
    echo "###############################################"
    echo -n "> "
    read input_domain_name
    domain_name=$(echo "$input_domain_name" | tr '[:upper:]' '[:lower:]')
    if [[ $domain_name == "https://"* ]]; then
        host_name=${domain_name:8}
        domain_name=$host_name
    fi
    if [[ $domain_name == "http://"* ]]; then
        host_name=${domain_name:7}
        domain_name=$host_name
    fi
    if [[ $domain_name == "www."* ]]; then
        www=true
        host_name=${domain_name:4}
        domain_name=$host_name
        echo "                                      www hostname detected"
        echo "                                      Checking" $domain_name
        echo ""
    fi
    endurl=`curl $1 -s -L -I -o /dev/null -w '%{url_effective}' $domain_name`
    echo "Redirects to:                         "$endurl
    dnsservers=`dig $domain_name ns +short`
    echo "DNS Servers set to:                   "$dnsservers
    if [[ "$dnsservers" == "" ]]; then
        echo "                                      ❌ No DNS Set. (Unregistered domain?)"
    fi
    checkarecord=`dig $domain_name +short`
    echo "A Record set to:                      "$checkarecord
    if [[ "$checkarecord" == "107.23.2.13" ]]; then
        echo "                                      ✅ A Record Set Correctly"
    else
        echo "                                      ❌ A Record INCORRECT"
    fi
    cname=`dig cname www.$domain_name +short`
    echo "CNAME for www set to:                 "$cname
        if [[ "$cname" == "domains.myvr.com." ]]; then
            echo "                                      ✅ CNAME Set Correctly"
        else
            echo "                                      ❌ CNAME INCORRECT"
        fi
}
