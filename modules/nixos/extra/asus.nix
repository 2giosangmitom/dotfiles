{
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
  services.supergfxd.enable = true;
  services.power-profiles-daemon.enable = true;
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };
}
