{ config, pkgs, inputs, ... }:

{  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    slack
    weechat-unwrapped

    docker
    docker-compose
    lazydocker

    shotcut

    # system benchmarking tools
    unixbench
    inputs.zen-browser.packages."${system}".default
    jetbrains-toolbox
    lazygit
    nix-prefetch-github
    stremio
    bluetui
    impala
    trippy
    haskellPackages.patat
    
    # System Detective
    binsider
    netscanner
    termshark
    btop

    presenterm

    nwg-look
    nwg-displays

    catppuccin-gtk
    bitwarden-cli
    direnv
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

    wf-recorder
    slurp

    (bibata-cursors.overrideAttrs (oldAttrs: {
      version = "2.0.6";
    }))
    mpv-unwrapped

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
    mupdf

    udiskie
    imv
    simple-mtpfs

    neovim
    go
    gcc
    rustup
    nodejs
    uv
    python313
    luajitPackages.luarocks
    rust-analyzer
  ];
}
