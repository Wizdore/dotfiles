{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./modules/hardware-configuration.nix
      ./modules/network.nix
      ./modules/sound.nix
      ./modules/locale.nix
      ./modules/greeter.nix
      ./modules/power-policy.nix
    ];


  # The Latest Mainline Linux Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.kernelParams = [ "fsync=1" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot = {
    kernelModules = [ "snd_hda_intel" ];
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;


   programs.dconf.enable = true;

  services.xserver.videoDrivers = [ "modesetting" ];  # For Intel integrated graphics


  # Defining my user account
  users.users.wizdore = {
    isNormalUser = true;
    description = "Shaon";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };

  # Configuring Git
  programs.git = {
    enable = true;
    package = pkgs.git;

    config = {
      user = {
        name = "Wizdore";
        email = "wizdore@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 30d --keep 30";
    flake = "/home/wizdore/.config/nix/";
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Make Zsh default
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Steam <3
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true; 
  };

  # Hyprland
  programs.hyprland.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    # Defining My Desktop
    wofi
    waybar
    hyprpaper
    hyprlock
    mako
    wl-clipboard
    clipse
    networkmanagerapplet

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
  ];


  environment.variables.EDITOR = "nvim";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk
      font-awesome
      symbola
      material-icons
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.fprintd = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

