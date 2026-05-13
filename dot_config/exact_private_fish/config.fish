if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Environment variables
set -gx PATH "/home/wizdore/.local/bin" $PATH
set -gx DOTNET_ASPIRE_CONTAINER_RUNTIME podman


set -g fish_key_bindings fish_vi_key_bindings


#ENVARS
set -Ux EDITOR nvim
set -Ux VISUAL nvim


set fish_greeting ""
# Yazi function with directory changing
function yazi-widget
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

function t
  # Check if any tmux session exists
  if tmux ls &>/dev/null
    # Attach to the most recently used session
    tmux attach-session -t (tmux ls | tail -n1 | cut -d: -f1)
  else
    # No sessions, create a new one named 'default'
    tmux new-session -s default
  end
end

function bind_all_modes
    set key $argv[1]
    set action $argv[2..-1]
    bind -M insert $key $action
    bind -M default $key $action
    bind -M visual $key $action
end

function cre
    set example (ls examples/ | sed 's/\.rs$//' | fzf \
        --prompt=" example: " \
        --pointer="▶" \
        --marker="✓" \
        --preview="bat --color=always --style=numbers,header --theme=base16 examples/{}.rs" \
        --preview-window="right:65%:border-left" \
        --layout=reverse \
        --border=rounded \
        --border-label=" cargo run --example " \
        --border-label-pos=3 \
        --height=80% \
        --margin=5%,5% \
        --padding=1,2 \
        --color="bg:#1c1c1c,bg+:#262626,fg:#b2b2b2,fg+:#d0d0d0,border:#444444,label:#6c6c6c,prompt:#af87af,pointer:#af87af,marker:#87af87,hl:#87af87,hl+:#afd787,header:#5f5f5f,info:#6c6c6c")
    if test -n "$example"
        cargo watch -q -c -x "run --example $example"
    end
end

bind_all_modes alt-s sesh-sessions
bind_all_modes alt-w yazi-widget
bind_all_modes \ck up-or-search
bind_all_modes \cj down-or-search

# Aliases
# alias tmux "tmux -f $TMUX_CONF"
alias .. 'cd ..'
alias bt bluetui
alias bwl 'bw lock'
alias bwu 'set -gx BW_SESSION (bw unlock --raw)'
alias c clear
alias cz chezmoi
alias cza 'chezmoi add --exact'
alias czd 'chezmoi diff'
alias cze 'chezmoi edit'
alias czg 'lazygit -p ~/.local/share/chezmoi'
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
