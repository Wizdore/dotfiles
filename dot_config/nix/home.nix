{ config, pkgs, inputs, ... }:
{
  home.username = "wizdore";
  home.homeDirectory = "/home/wizdore";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = [

  ];

  home.file = {
    ".config/git/config".source = ./config/git/config;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    XCURSOR_THEME = "Bibata-Modern-Amber";
    XCURSOR_SIZE = "24"; # optional
  };

  gtk = {
    enable = true;
    theme.name = "catppuccin-mocha";
    cursorTheme.name = "Bibata-Modern-Amber";
    iconTheme.name = "Flatery-dark";
  };

  programs.home-manager.enable = true;
}
