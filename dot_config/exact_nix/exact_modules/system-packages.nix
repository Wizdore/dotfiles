{ config, pkgs, ... }:

{  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Defining My Desktop
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
    btop
    fastfetch
    jq
    hyperfine

    bibata-cursors

    neovim
    curl
    wget
    gcc
    zig
    unrar
    unzip

    python312
    uv
    nodejs_22
    alsa-ucm-conf
    alsa-utils

    usbutils
    ripgrep

    evtest

    ungoogled-chromium
    tridactyl-native
    yazi
    wirelesstools
    starship
    atuin
    wineWowPackages.stable
    winetricks
    bottles
    qbittorrent-nox
    nh
    rsync
    magic-wormhole
    nwg-displays
    entr
    brightnessctl

    delta
    difftastic
    diff-so-fancy

    cargo
    go
    bat
    eza
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
