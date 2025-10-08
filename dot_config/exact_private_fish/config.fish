if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Environment variables
set -gx PATH "/home/wizdore/.local/bin" $PATH
set -gx DOTNET_ASPIRE_CONTAINER_RUNTIME podman


set -g fish_key_bindings fish_vi_key_bindings

set fish_greeting ""
# Yazi function with directory changing
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if test -f "$tmp"
        set cwd (cat "$tmp")
        if test -n "$cwd" -a "$cwd" != "$PWD"
            cd "$cwd"
        end
    end
    rm -f "$tmp"
end

# Sesh sessions function
function sesh-sessions
    set session (sesh list | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    if test -n "$session"
        sesh connect $session
    end
end

# Key bindings
bind \es sesh-sessions
bind \ew y
bind \ck up-or-search
bind \cj down-or-search

# Aliases
alias tmux "tmux -f $TMUX_CONF"
alias .. 'cd ..'
alias bt bluetui
alias bwl 'bw lock'
alias bwu 'set -gx BW_SESSION (bw unlock --raw)'
alias c clear
alias cz chezmoi
alias cza 'chezmoi add --exact'
alias czd 'chezmoi diff'
alias cze 'chezmoi edit'
alias czu 'chezmoi update -v'
alias dvx devbox
alias kl 'pkill -9'
alias ls eza
alias l 'eza -a'
alias ld 'sudo lazydocker'
alias lg lazygit
alias ll 'eza -la'
alias s sudo
alias v nvim
alias vv 'nvim .'
alias zz 'z -'

# zv function - cd with zoxide and open nvim
function zv
    z $argv[1]
    and nvim .
end

# Initialize external tools
if command -q starship
    starship init fish | source
end

if command -q zoxide
    zoxide init fish | source
end

if command -q atuin
    atuin init fish | source
end

if command -q direnv
    direnv hook fish | source
end
