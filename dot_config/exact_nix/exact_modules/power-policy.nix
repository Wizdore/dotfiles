{ config, pkgs, ... }:
{
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand"; 
  boot.kernelParams = [ "intel_pstate=passive" ]; 
  services.tlp.enable = true;
  services.thermald.enable = true;
  services.tlp.settings = {
    CPU_BOOST_ON_AC = 0;
    CPU_BOOST_ON_BAT = 0;
  };

}
