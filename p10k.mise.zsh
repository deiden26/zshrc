# Powerlevel10k prompt segments for mise
# [Feature request: add segment for mise](https://github.com/romkatv/powerlevel10k/issues/2212)
# [Adapted from](https://github.com/2KAbhishek/dots2k/blob/main/config/zsh/prompt/p10k.mise.zsh)
# Usage in ~/.zshrc:
#   [[ -f ~/.config/shell/p10k.mise.zsh ]] && source ~/.config/shell/p10k.mise.zsh

() {
    function prompt_mise() {
        local plugins=("${(@f)$(mise ls --current --offline 2>/dev/null | awk '!/\(symlink\)/ && $3!="~/.tool-versions" && $3!="~/.config/mise/config.toml" && $3!="(missing)" {if ($1) print $1, $2}')}")

        local plugin
        for plugin in ${(k)plugins}; do
            local parts=("${(@s/ /)plugin}")
            local tool=${(U)parts[1]}
            local version=${parts[2]}
            p10k segment -r -i "${tool}_ICON" -s $tool -t "$version"
        done
    }

    # Colors
    typeset -g POWERLEVEL9K_MISE_DOTNET_CORE_BACKGROUND=134
    typeset -g POWERLEVEL9K_MISE_ELIXIR_FOREGROUND=129
    typeset -g POWERLEVEL9K_MISE_ERLANG_FOREGROUND=125
    typeset -g POWERLEVEL9K_MISE_FLUTTER_FOREGROUND=38
    typeset -g POWERLEVEL9K_MISE_GO_FOREGROUND=37
    typeset -g POWERLEVEL9K_MISE_GO_VISUAL_IDENTIFIER_EXPANSION=$'\ue627'
    typeset -g POWERLEVEL9K_MISE_HASKELL_FOREGROUND=172
    typeset -g POWERLEVEL9K_MISE_JAVA_FOREGROUND=32
    typeset -g POWERLEVEL9K_MISE_JULIA_FOREGROUND=70
    typeset -g POWERLEVEL9K_MISE_JUST_FOREGROUND=179
    typeset -g POWERLEVEL9K_MISE_JUST_VISUAL_IDENTIFIER_EXPANSION=$'\U000F08EA'
    typeset -g POWERLEVEL9K_MISE_LUA_FOREGROUND=32
    typeset -g POWERLEVEL9K_MISE_NODE_FOREGROUND=70
    typeset -g POWERLEVEL9K_MISE_OPA_FOREGROUND=75
    typeset -g POWERLEVEL9K_MISE_OPA_VISUAL_IDENTIFIER_EXPANSION=$'\uEB53'
    typeset -g POWERLEVEL9K_MISE_PERL_FOREGROUND=67
    typeset -g POWERLEVEL9K_MISE_PHP_FOREGROUND=99
    typeset -g POWERLEVEL9K_MISE_PNPM_FOREGROUND=208
    typeset -g POWERLEVEL9K_MISE_PNPM_VISUAL_IDENTIFIER_EXPANSION=$'\uEB29'
    typeset -g POWERLEVEL9K_MISE_POSTGRES_FOREGROUND=31
    typeset -g POWERLEVEL9K_MISE_PYTHON_FOREGROUND=37
    typeset -g POWERLEVEL9K_MISE_RUBY_FOREGROUND=168
    typeset -g POWERLEVEL9K_MISE_RUST_FOREGROUND=37
    typeset -g POWERLEVEL9K_MISE_UV_FOREGROUND=141
    typeset -g POWERLEVEL9K_MISE_UV_VISUAL_IDENTIFIER_EXPANSION=$'\uF0E7'

    # Substitute the default asdf prompt element
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=("${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]/asdf/mise}")
}
