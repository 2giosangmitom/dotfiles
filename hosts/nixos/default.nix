{
  imports = [
    ./hardware-configuration.nix
  ];

  # Fix screen artifacts on amdgpu
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
  ];
}
