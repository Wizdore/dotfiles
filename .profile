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

#Environment variable for GoLang
export GOBIN=/home/wizdore/go/bin
export GOPATH=/home/wizdore/go

export PATH=$PATH:$GOBIN

#Environment variable for RTV to change the browser
export RTV_BROWSER=qutebrowser