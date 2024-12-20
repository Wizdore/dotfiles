{ config, pkgs, ... }:
{
  networking.networkmanager.enable = true;
  networking.hostName = "capgemini";

  networking.wireguard.enable = true;
}
