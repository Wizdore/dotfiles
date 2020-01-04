###################
##    aliases    ##
###################

alias v="nvim"
alias activate="source venv/bin/activate"
alias running_services="systemctl --type=service --state=running"
alias nb="newsboat"
alias nm="neomutt"
alias dk="docker"
alias s="sudo"
alias neofetch='neofetch --ascii_distro Arch_old --disable memory theme icons --ascii_bold on'

# Better alternative of less
alias les='vim -u /usr/share/vim/vim82/macros/less.vim'


# alias for dotfiles repository 
alias dgit="/usr/bin/git --git-dir=$HOME/Downloads/gits/dotfiles --work-tree=$HOME"

alias update="sudo pacman -Syyu"
alias tb="nc termbin.com 9999 | xclip -se c"
alias l="exa -Fa --group-directories-first"

#########################
##    env variables    ##
#########################

export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=/usr/bin/nvim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/w3m

export KEYTIMEOUT=1
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_CTRL_T_OPTS='--preview "bat -p --tabs 2 --color=always {}" --preview-window right:50%:noborder | head -500'
export FZF_DEFAULT_OPTS='--reverse --height=90%'

#Environment variable for GoLang
export GOBIN=/home/wizdore/go/bin
export GOPATH=/home/wizdore/go
export PATH=$PATH:$GOBIN

#Environment variable for RTV to change the browser
export RTV_BROWSER=qutebrowserexport
