{ config, pkgs, lib, ... }:

# Config for Germany per default. Change to your location
{
  system.stateVersion = "22.05";
  i18n.defaultLocale = "de_DE.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  hardware = {
    # cpu.amd.updateMicrocode = true; # Change to your CPU manufacturer
    pulseaudio.enable = false;
    enableRedistributableFirmware = true;

    # Depends on hardware
    # bluetooth = { 
      # enable = true;
      # powerOnBoot = false;
    # };
  };

  time = {
    timeZone = "Europe/Berlin";
    hardwareClockInLocalTime = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 0;

      systemd-boot = {
        enable = true;
        configurationLimit = null;
        consoleMode = "max";
      };
    };
  };
}
