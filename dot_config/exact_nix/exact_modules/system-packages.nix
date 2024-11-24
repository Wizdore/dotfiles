{ config, pkgs, inputs, ... }:

{  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    lazydocker

    # system benchmarking tools
    unixbench
    inputs.zen-browser.packages."${system}".specific
    jetbrains-toolbox
    jetbrains-mono
    lazygit
    nix-prefetch-github
    stremio
    bluetui
    impala
    haskellPackages.patat
    
    # System Detective
    binsider
    netscanner
    termshark
    btop

    nwg-look
    nwg-displays

    catppuccin-gtk
    bitwarden-cli
    lua-language-server
    nodejs
    python313
    uv
    devbox
    wofi
    waybar
    hyprpaper
    hyprlock
    hyprshot
    mako
    libnotify
    wl-clipboard
    clipse
    networkmanagerapplet
    fastfetch
    jq
    hyperfine

    bibata-cursors
    mpv-unwrapped

    neovim
    curl
    wget
    unrar
    unzip

    alsa-ucm-conf
    alsa-utils

    usbutils
    ripgrep
    fd

    evtest

    ungoogled-chromium
    tridactyl-native
    yazi
    wirelesstools
    starship
    atuin
    qbittorrent-nox
    nh
    rsync
    magic-wormhole
    entr
    brightnessctl

    delta
    difftastic
    diff-so-fancy

    bat
    eza
    dust
    powertop
    tldr
    fzf
    tmux
    sesh
    kitty
    chezmoi
    zsh
    psmisc

    zoxide
    pavucontrol

    udiskie
    imv
    simple-mtpfs
  ];
}
