{ config, pkgs, ... }:
{
  networking.networkmanager.enable = true;
  networking.hostName = "capgemini";
  
  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 41641 51820 ];
    trustedInterfaces = [ "tailscale0" "wg0" ];
  };
}
