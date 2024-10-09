{ config, pkgs, ... }:
{
  powerManagement.enable = true;
  programs.auto-cpufreq.enable = true;
  programs.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      turbo = "auto";
    };

    battery = {
      governor = "powersave";
      turbo = "never";
    };
  };
}
