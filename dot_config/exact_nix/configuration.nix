{ config, pkgs, inputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./modules/hardware-configuration.nix
      ./modules/network.nix
      ./modules/sound.nix
      ./modules/locale.nix
      ./modules/greeter.nix
      ./modules/power-policy.nix
      ./modules/system-packages.nix
    ];


  # The Latest Mainline Linux Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.kernelParams = [ "fsync=1" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot = {
    kernelModules = [ "snd_hda_intel" "fuse" "uvcvideo" ];
  };

  
  # Required for AppImages
  security.wrappers.fusermount.source = "${pkgs.fuse}/bin/fusermount";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Only need to specify 32-bit support now

    extraPackages = with pkgs; [
      intel-media-driver    # modern Intel GPUs (Broadwell and newer)
      intel-compute-runtime # OpenCL support
      vaapiIntel           # VA-API backend
      libvdpau-va-gl       # VDPAU backend using VA-API
    ];

    # 32-bit support packages for Intel
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel
      libva
    ];
  };

  virtualisation.docker.enable = true;

  services.blueman.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # For enabling external mounting
  services.udisks2.enable = true;
  services.udev.packages = [ pkgs.udisks2 ];

  programs.dconf.enable = true;

  services.xserver.videoDrivers = [ "modesetting" ];  # For Intel integrated graphics

  # Defining my user account
  users.users.wizdore = {
    isNormalUser = true;
    description = "Shaon";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "docker" ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
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

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Standard dynamic linking
      stdenv.cc.cc
      stdenv.cc.libc
      
      # Core system libraries
      zlib
      glib
      openssl
      
      # Python-related
      python313
      python313.pkgs.pip
      
      # Additional runtime libraries
      curl
      util-linux
      icu
      zlib
      
      # Additional dependencies that might be needed
      libstdcxx5
      gcc.cc.lib
      glibc
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Make Zsh default
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Steam setup <3
  programs.java.enable = true; 
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true; 
    gamescopeSession.enable = true;
  };

  # Hyprland
  programs.hyprland.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.variables.EDITOR = "nvim";
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = "Bibata-Modern-Amber"; # Bibata-Modern-{Ice,Classic} for {white, Dark} version
    XCURSOR_SIZE = "24";
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans 
      noto-fonts
      font-awesome
      symbola
      material-icons
      cozette
      liberation_ttf
      fira-code
      fira-code-symbols
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrains Mono" "DejaVu Sans Mono" ];
        sansSerif = [ "Noto Sans" "DejaVu Sans" ];
        serif = [ "Noto Serif" "DejaVu Serif" ];
      };
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "full";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

